return {
  {
    "ruifm/gitlinker.nvim",
    cond = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("gitlinker").setup({
        mappings = "<leader>gy",
      })
    end,
  },
}
