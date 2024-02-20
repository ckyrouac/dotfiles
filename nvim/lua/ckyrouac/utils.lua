local M = {}

local function dapui_is_open()
  for _, info in ipairs(vim.fn.getbufinfo()) do
    if string.find(info.name, "/DAP ") ~= nil and info.hidden == 0 then
      return true
    end
  end

  return false
end

M.dapui_is_open = dapui_is_open

function M.dapui_refresh()
  if dapui_is_open() then
    require('dapui').open({reset=true})
  end
end

return M
