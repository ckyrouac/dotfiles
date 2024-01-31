return {
  {
    "j-hui/fidget.nvim",
    cond = true,
    lazy = false,
    config = function ()
      require("fidget").setup()
    end
  },
}
