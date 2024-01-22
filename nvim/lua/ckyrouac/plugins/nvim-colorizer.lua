return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*",
        lua = {
          hsl_fn = true,
        },
      })
    end,
  },
}
