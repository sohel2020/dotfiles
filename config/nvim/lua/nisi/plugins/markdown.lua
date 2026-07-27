return {
  {
    -- In-buffer markdown rendering (headings, tables, code blocks, checkboxes)
    "MeanderingProgrammer/render-markdown.nvim",
    cond = not vim.g.vscode,
    ft = { "markdown", "md", "codecompanion", "Avante" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render", ft = "markdown" },
    },
  },
}
