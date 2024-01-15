return {
  {
    "rcarriga/nvim-dap-ui",
    config = function ()
      local dapui = require("dapui")
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close()
      -- end
      dapui.setup()

      -- breakpoint colors
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939'})
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef'})
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379'})

      -- dap icons
      vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint'})
      vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint' })
      vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped' })
    end
  }
}
