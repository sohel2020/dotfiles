-- Run a shell command, return ok (bool) + output (string)
local function git(cmd)
  local out = vim.fn.system(cmd)
  return vim.v.shell_error == 0, out
end

-- Detect the default branch (main vs master) via origin/HEAD, with fallback
local function detect_main()
  local ref = vim.trim(vim.fn.system("git symbolic-ref --quiet --short refs/remotes/origin/HEAD"))
  if vim.v.shell_error == 0 and ref ~= "" then
    return (ref:gsub("^origin/", ""))
  end
  for _, b in ipairs({ "main", "master" }) do
    git("git rev-parse --verify " .. b)
    if vim.v.shell_error == 0 then
      return b
    end
  end
  return nil
end

local function is_dirty()
  return vim.trim(vim.fn.system("git status --porcelain")) ~= ""
end

-- Nudge neo-tree to re-read the filesystem and git status after a git op,
-- so the tree reflects commits/checkouts without waiting on its own polling.
local function refresh_neotree()
  local ok, mgr = pcall(require, "neo-tree.sources.manager")
  if ok then
    pcall(mgr.refresh, "filesystem")
  end
  local ok_ev, events = pcall(require, "neo-tree.events")
  if ok_ev then
    pcall(events.fire_event, events.GIT_EVENT)
  end
end

-- Checkout the default branch and fast-forward pull. Aborts on a dirty tree.
local function checkout_main()
  if is_dirty() then
    vim.notify("Working tree dirty. Commit or stash first.", vim.log.levels.WARN)
    return
  end
  local main = detect_main()
  if not main then
    vim.notify("Could not detect main/master branch.", vim.log.levels.ERROR)
    return
  end
  local steps = {
    { "git checkout " .. main, "checkout " .. main },
    { "git pull --ff-only", "pull " .. main },
  }
  for _, step in ipairs(steps) do
    local ok, out = git(step[1])
    if not ok then
      vim.notify("Failed: " .. step[2] .. "\n" .. out, vim.log.levels.ERROR)
      return
    end
  end
  refresh_neotree()
  vim.notify("On " .. main .. ", pulled")
end

-- New branch off main, pulling main first. Aborts on a dirty tree.
local function new_branch_from_main()
  if is_dirty() then
    vim.notify("Working tree dirty. Commit or stash first.", vim.log.levels.WARN)
    return
  end
  local main = detect_main()
  if not main then
    vim.notify("Could not detect main/master branch.", vim.log.levels.ERROR)
    return
  end
  vim.ui.input({ prompt = "New branch (from " .. main .. "): " }, function(name)
    if not name or name == "" then
      return
    end
    local steps = {
      { "git checkout " .. main, "checkout " .. main },
      { "git pull --ff-only", "pull " .. main },
      { "git checkout -b " .. vim.fn.shellescape(name), "create " .. name },
    }
    for _, step in ipairs(steps) do
      local ok, out = git(step[1])
      if not ok then
        vim.notify("Failed: " .. step[2] .. "\n" .. out, vim.log.levels.ERROR)
        return
      end
    end
    refresh_neotree()
    vim.notify("On new branch " .. name .. " (from " .. main .. ")")
  end)
end

-- Sync the current branch: stage all, commit, pull --rebase, push.
local function sync()
  vim.ui.input({ prompt = "Commit message: " }, function(msg)
    if not msg or msg == "" then
      return
    end
    local ok, out = git("git add -A")
    if not ok then
      vim.notify("add failed\n" .. out, vim.log.levels.ERROR)
      return
    end
    ok, out = git("git commit -m " .. vim.fn.shellescape(msg))
    if not ok and not out:match("nothing to commit") then
      vim.notify("commit failed\n" .. out, vim.log.levels.ERROR)
      return
    end
    -- No upstream yet? Skip pull (nothing to rebase onto) and push with -u.
    git("git rev-parse --abbrev-ref --symbolic-full-name @{u}")
    local has_upstream = vim.v.shell_error == 0
    if has_upstream then
      ok, out = git("git pull --rebase")
      if not ok then
        vim.notify("pull --rebase failed, resolve conflicts\n" .. out, vim.log.levels.ERROR)
        return
      end
      ok, out = git("git push")
    else
      ok, out = git("git push -u origin HEAD")
    end
    if not ok then
      vim.notify("push failed\n" .. out, vim.log.levels.ERROR)
      return
    end
    refresh_neotree()
    vim.notify("Synced: commit, pull --rebase, push")
  end)
end

return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      { "<leader>gr", "<cmd>Gread<cr>", desc = "Read file from git" },
      { "<leader>gb", "<cmd>G blame<cr>", desc = "Git blame" },
      { "<leader>gC", "<cmd>G commit<cr>", desc = "Git Commit" },
      { "<leader>gp", "<cmd>G pull<cr>", desc = "Git Pull" },
      { "<leader>gm", checkout_main, desc = "Checkout main + pull" },
      { "<leader>gN", new_branch_from_main, desc = "New branch from main (pull first)" },
      { "<leader>gS", sync, desc = "Sync (commit + pull --rebase + push)" },
      {
        "<leader>gP",
        function()
          if vim.fn.confirm("git push?", "&Yes\n&No", 2) == 1 then
            vim.cmd("G push")
          end
        end,
        desc = "Git Push",
      },
      {
        "<leader>gn",
        function()
          vim.ui.input({ prompt = "New branch: " }, function(name)
            if name and name ~= "" then
              vim.cmd("G checkout -b " .. name)
            end
          end)
        end,
        desc = "New Branch",
      },
    },
    dependencies = { "tpope/vim-rhubarb" },
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        -- Helper function to set buffer-local keymaps
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Previous hunk" })

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage hunk" })
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset hunk" })
        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Blame line" })
        map("n", "<leader>uB", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, { desc = "Diff this file" })
        map("n", "<leader>uX", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
      end,
    },
  },
}
