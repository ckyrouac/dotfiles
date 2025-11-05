return {
  {
    "rcarriga/nvim-dap-ui",
    cond = false,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
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
      dapui.setup({

        layouts = {
          {
            elements = {
              {
                id = "watches",
                size = 0.3,
              },
              {
                id = "scopes",
                size = 0.35,
              },
              {
                id = "stacks",
                size = 0.2,
              },
              {
                id = "breakpoints",
                size = 0.15,
              },
            },
            position = "left",
            size = 0.3,
          },
          {
            elements = {
              {
                id = "repl",
                size = 0.5,
              },
              {
                id = "console",
                size = 0.5,
              },
            },
            position = "bottom",
            size = 0.3,
          },
        },
      })

      -- breakpoint colors
      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#555530" })
      vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })

      -- dap icons
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStoppedLinehl" })

      -- window names
      -- vim.api.nvim_create_autocmd({ "FileType", "BufNew", "BufAdd", "WinNew", "WinEnter" }, {
      vim.api.nvim_create_autocmd({  "BufEnter" }, {
        pattern = { "*" },
        callback = function()
          if vim.bo.filetype == "dapui_watches" then
            vim.opt_local.winbar = " Watches"
          elseif vim.bo.filetype == "dapui_stacks" then
            vim.opt_local.winbar = " Stacks"
          elseif vim.bo.filetype == "dapui_breakpoints" then
            vim.opt_local.winbar = " Breakpoints"
          elseif vim.bo.filetype == "dapui_scopes" then
            vim.opt_local.winbar = " Scopes"
          elseif vim.bo.filetype == "dapui_console" then
            vim.opt_local.statusline = "Console"
          elseif vim.bo.filetype == "dap-repl" then
            vim.opt_local.statusline = "REPL"
          end
        end,
      })
    end,
  },
}
