-- Window focus/unfocus actions
local function set_nvim_tree_highlight()
  vim.cmd([[au FileType TelescopePrompt* setlocal nocursorline]])
  vim.cmd([[au FileType TelescopePrompt* setlocal nonumber]])
  vim.cmd([[au FileType TelescopePrompt* setlocal nornu]])

  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
    pattern = { "*" },
    callback = function()
      vim.o.cursorline = true
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
    pattern = { "*" },
    callback = function()
      vim.o.cursorline = false
    end,
  })
end
set_nvim_tree_highlight()
