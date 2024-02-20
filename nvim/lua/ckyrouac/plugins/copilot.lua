return {
  {
    "zbirenbaum/copilot.lua",
    cond = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-y>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          javascript = true,
          typescript = true,
          rust = true,
          go = true,
          lua = true,
          ["*"] = false,
        },
      })
    end,
  },
}
