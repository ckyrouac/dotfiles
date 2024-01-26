return {
  {
    "mfussenegger/nvim-dap",
    config = function ()
      require("dap.ext.vscode").load_launchjs()
      require("overseer").patch_dap(true)
    end
  },
}
