return {
  {
    "LhKipp/nvim-nu",
    cond = true,
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("nu").setup({
        use_lsp_features = true,
      })
    end,
  },
}