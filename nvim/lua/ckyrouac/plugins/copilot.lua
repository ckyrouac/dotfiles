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
        copilot_model = "gemini-2.5-pro",
        panel = { enabled = false },
        filetypes = {
          javascript = true,
          typescript = true,
          rust = true,
          go = true,
          lua = true,
          c = true,
          ["*"] = false,
        },
      })
    end,
  },
}
