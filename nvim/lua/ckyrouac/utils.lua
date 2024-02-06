local M = {}

local function dapui_is_open()
  local List = require("plenary.collections.py_list")
  local dapUIFiletypes = List({
    "dapui_watches",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_scopes",
    "dapui_console",
    "dapui_console",
    "dap-repl",
  })

  local buffers = vim.api.nvim_list_bufs()

  for buf in pairs(buffers) do
    local filetype = vim.fn.getbufvar(buf, "&filetype")
    if dapUIFiletypes:contains(filetype) then
      return true
    end
  end

  return false
end

function M.dapui_refresh()
  if dapui_is_open() then
    require('dapui').open({reset=true})
  end
end

return M
