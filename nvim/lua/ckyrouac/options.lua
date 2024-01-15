-- Disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- Set highlight on search
vim.o.hlsearch = true

vim.o.clipboard = 'unnamedplus'

-- relative line numbers
vim.api.nvim_create_autocmd({"BufEnter","FocusGained","InsertLeave","WinEnter"}, {
  pattern = {"*"},
  callback = function()
    if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "SidebarNvim" then
      vim.o.rnu = false
      vim.o.number = false
    else
      vim.o.rnu = true
    end
  end
})

vim.api.nvim_create_autocmd({"BufLeave","FocusLost","InsertEnter","WinLeave"}, {
  pattern = {"*"},
  callback = function()
    if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "SidebarNvim" then
      vim.o.rnu = false
      vim.o.number = false
    else
      vim.o.rnu = false
      vim.o.number = true
    end
  end
})

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
