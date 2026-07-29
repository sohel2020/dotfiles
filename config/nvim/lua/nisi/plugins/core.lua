return {
  "tpope/vim-unimpaired",
  "tpope/vim-ragtag",
  "tpope/vim-abolish",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "editorconfig/editorconfig-vim", -- TODO is this still required?
  {
    "andymass/vim-matchup",
    cond = not vim.g.vscode,
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "itchyny/vim-qfedit",
    cond = not vim.g.vscode,
    event = "VeryLazy",
  },
  {
    "greggh/claude-code.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup({
        -- Terminal window settings
        window = {
          split_ratio = 0.3,
          position = "botright",
          enter_insert = true,
          hide_numbers = true,
          hide_signcolumn = true,
          -- Floating window configuration (only applies when position = "float")
          float = {
            width = "80%",
            height = "80%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "rounded",
          },
        },
        -- File refresh settings
        refresh = {
          enable = true,
          updatetime = 100,
          timer_interval = 1000,
          show_notifications = true,
        },
        -- Git project settings
        git = {
          use_git_root = true,
        },
        -- Shell-specific settings
        shell = {
          separator = "&&",
          pushd_cmd = "pushd",
          popd_cmd = "popd",
        },
        -- Command settings
        command = "claude",
        -- Command variants
        command_variants = {
          -- Conversation management
          continue = "--continue",
          resume = "--resume",

          -- Output options
          verbose = "--verbose",
        },
        -- Keymaps
        keymaps = {
          toggle = {
            normal = "<C-,>",
            terminal = "<C-,>",
            variants = {
              continue = "<leader>cC",
              verbose = "<leader>cV",
            },
          },
          window_navigation = true,
          scrolling = true,
        },
      })

      -- Leader alias for the toggle (discoverable in which-key), keeps <C-,>
      vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    cond = not vim.g.vscode,
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          require("grug-far").open()
        end,
        mode = { "n", "v" },
        desc = "Search & Replace",
      },
      {
        "<leader>sw",
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end,
        desc = "Search & Replace word",
      },
      {
        "<leader>sp",
        function()
          require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
        end,
        desc = "Search & Replace current file",
      },
    },
  },
  {
    "nat-418/boole.nvim",
    opts = {
      mappings = {
        increment = "<C-a>",
        decrement = "<C-x>",
      },
      -- User defined loops
      additions = {
        -- { "Foo", "Bar" },
        -- { "tic", "tac", "toe" },
      },
      allow_caps_additions = {
        { "enable", "disable" },
        -- enable → disable
        -- Enable → Disable
        -- ENABLE → DISABLE
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      spec = {
        { "<leader>f", group = "find/file", icon = "🔍" },
        { "<leader>g", group = "git", icon = "🌿" },
        { "<leader>h", group = "git hunks", icon = "🩹" },
        { "<leader>c", group = "claude", icon = "🤖" },
        { "<leader>x", group = "diagnostics/code", icon = "🩺" },
        { "<leader>s", group = "search/replace", icon = "🔁" },
        { "<leader>u", group = "ui/toggle", icon = "🎨" },
        { "<leader>t", group = "terminal", icon = "💻" },
        { "<leader>p", group = "project", icon = "📁" },
        { "<leader>b", group = "buffer", icon = "📄" },
        -- Hide interesting-word highlight mappings from the popup
        { "<leader>0", hidden = true },
        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader>6", hidden = true },
        { "<leader>N", hidden = true },
        { "<leader>a", hidden = true },
        { "<leader>A", hidden = true },
        { "<leader>E", hidden = true },
        { "<leader>y", hidden = true, mode = "v" },
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    cond = not vim.g.vscode,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
}
