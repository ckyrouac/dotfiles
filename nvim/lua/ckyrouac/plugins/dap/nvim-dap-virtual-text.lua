return {
  {
    "theHamsta/nvim-dap-virtual-text",
    cond = true,
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
}
