return {
  {
    "zbirenbaum/copilot-cmp",
    cond = false,
    dependencies = { "zbirenbaum/copilot.lua", "ckyrouac/nvim-cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
