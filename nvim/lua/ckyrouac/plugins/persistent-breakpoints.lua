return {
  {
    "ckyrouac/persistent-breakpoints.nvim",
    cond = true,
    lazy = false,
    config = function()
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
      })
    end,
  },
}
