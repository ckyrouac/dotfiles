return {
  {
    "zbirenbaum/copilot.lua",
    cond = false,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
        },
        panel = { enabled = false },
      })
    end,
  },
}
