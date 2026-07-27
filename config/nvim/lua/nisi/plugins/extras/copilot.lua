return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    cond = not vim.g.vscode,
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          close = "<Esc>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-x>",
        },
      },
      panel = {
        enabled = false,
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              show_multiline = true,
            },
          },
        },
      },
    },
  },
}
