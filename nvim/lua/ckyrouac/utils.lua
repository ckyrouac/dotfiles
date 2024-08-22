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

local function is_floating(winid)
  local cfg = vim.api.nvim_win_get_config(winid)
  return cfg.relative ~= ''
end

local function list_floating_windows()
  local all_wins = vim.api.nvim_list_wins()
  local floating_wins = {}

  for _, winid in ipairs(all_wins) do
    if is_floating(winid) then
      local full_attrs = {}
      full_attrs.win_cfg = vim.api.nvim_win_get_config(winid)
      full_attrs.bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winid))
      full_attrs.buftype = vim.api.nvim_get_option_value("buftype", {buf = vim.api.nvim_win_get_buf(winid)})
      full_attrs.filetype = vim.api.nvim_get_option_value("filetype", {buf = vim.api.nvim_win_get_buf(winid)})
      table.insert(floating_wins, full_attrs)
    end
  end

  return floating_wins
end

local function print_inspect()
  print(vim.inspect(list_floating_windows()))
end

vim.keymap.set("n", "<leader>j", print_inspect, { silent = true, desc = "Rust Hover" })

return M
