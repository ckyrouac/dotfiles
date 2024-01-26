return {
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup({
        dap = false, --patch dap in dap setup
      })
    end,
  },
}
