return {
  {
    "norcalli/nvim-colorizer.lua",
    cond = true,
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
