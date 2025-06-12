local List = require("plenary.collections.py_list")
local DisableLineNumberWindowList = List({
  "NvimTree",
  "SidebarNvim",
  "GitSigns*",
  "HoverHint",
  "dapui_watches",
  "dapui_stacks",
  "dapui_breakpoints",
  "dapui_scopes",
  "dapui_console",
  "dapui_console",
  "dap-repl",
  "noice",
})

vim.o.signcolumn = "no"
vim.o.foldcolumn = "0"

local augroup = vim.api.nvim_create_augroup("LineNumbersSplit", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "WinEnter" }, {
  group = augroup,
  pattern = { "*" },
  callback = function()
    if DisableLineNumberWindowList:contains(vim.bo.filetype) or vim.bo.filetype == "" or vim.bo.buftype == 'nofile' then
      vim.o.rnu = false
      vim.o.number = false
      vim.o.signcolumn = "no"
      vim.o.foldcolumn = "0"
    else
      vim.o.number = true
      vim.o.rnu = true

      vim.o.signcolumn = "yes"
      vim.o.foldcolumn = "1"
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "WinLeave" }, {
  group = augroup,
  pattern = { "*" },
  callback = function()
    if DisableLineNumberWindowList:contains(vim.bo.filetype) or vim.bo.filetype == "" or vim.bo.buftype == 'nofile' then
      vim.o.rnu = false
      vim.o.number = false
      vim.o.signcolumn = "no"
      vim.o.foldcolumn = "0"
    else
      vim.o.number = true
      vim.o.rnu = false

      vim.o.signcolumn = "yes"
      vim.o.foldcolumn = "1"
    end
  end,
})
