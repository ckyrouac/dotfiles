return {
  {
    "Weissle/persistent-breakpoints.nvim",
    cond = true,
    config = function()
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
      })
    end,
  },
}
