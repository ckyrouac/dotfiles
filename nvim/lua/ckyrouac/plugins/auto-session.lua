return {
  {
    "rmagatti/auto-session",
    cond = true,
    config = function()
      require("auto-session").setup({})
    end,
  },
}
