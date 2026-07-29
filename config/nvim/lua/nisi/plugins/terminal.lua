return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<c-/>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
      { "<c-_>", "<cmd>ToggleTerm<cr>", desc = "which_key_ignore", mode = { "n", "t" } },
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Float Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle Vertical Terminal" },
    },
    opts = {
      direction = "horizontal",
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = nil,
      shade_terminals = true,
      persist_size = true,
      persist_mode = true,
      start_in_insert = true,
      float_opts = {
        border = "curved",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Terminal-mode navigation: escape and window moves without leaving term first.
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function()
          local o = { buffer = 0 }
          vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], o)
          vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], o)
          vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], o)
          vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], o)
          vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], o)
        end,
      })
    end,
  },
}
