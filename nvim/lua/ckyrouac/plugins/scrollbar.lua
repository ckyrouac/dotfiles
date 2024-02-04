return {
  {
    "petertriho/nvim-scrollbar",
    config = function ()
      require("scrollbar").setup({
        set_highlights = false,
      })
    end
  }
}
