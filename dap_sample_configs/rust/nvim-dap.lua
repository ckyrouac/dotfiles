local dap = require("dap")
local job = require("plenary.job")

dap.adapters = {
  lldb = {
    executable = {
      args = {
        "--liblldb",
        "/home/chris/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so",
        "--port",
        "${port}",
      },
      command = "/home/chris/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
    },
    host = "127.0.0.1",
    port = "${port}",
    type = "server",
  },
}

-- rust config that runs cargo build before opening dap ui and starting Debugger
-- shows cargo build status as fidget progress
dap.configurations.rust = {
  {
    args = {},
    cwd = vim.fn.getcwd(),
    name = "main",
    program = function()
      return coroutine.create(function(dap_run_co)
        local progress = require("fidget.progress")

        local handle = progress.handle.create({
          title = "cargo build",
          lsp_client = { name = "Debugger" },
          percentage = 0,
        })

        local build_job = job:new({
          command = "cargo",
          args = { "build", "--color=never" },
          cwd = vim.fn.getcwd(),
          enable_handlers = true,
          on_stderr = vim.schedule_wrap(function (_, output)
            handle:report({
              message = output,
              percentage = handle.percentage + 0.3
            })
          end),
          on_exit = function(_, return_val)
            vim.schedule(function()
              if return_val ~= 0 then
                handle:report({
                  message = "Error during cargo build",
                  percentage = 100,
                })
              else
                handle:finish()
                coroutine.resume(dap_run_co, vim.fn.getcwd() .. "/target/debug/project_name")
              end
            end)
          end,
        })

        build_job:start()
      end)
    end,
    request = "launch",
    stopOnEntry = false,
    type = "lldb",
  },
}
