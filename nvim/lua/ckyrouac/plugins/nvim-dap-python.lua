return {
  {
    "mfussenegger/nvim-dap-python",
    cond = false,
    config = function()
      require("dap-python").setup("/home/chris/.pyenv/shims/python")
    end,
  }
}
