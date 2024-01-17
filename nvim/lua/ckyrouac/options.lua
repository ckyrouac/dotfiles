-- Disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- clipboard
-- vim.g.clipboard = 'unnamedplus'
vim.g.clipboard = {
  name = 'myClipboard',
  copy = {
    ['+'] = {'wl-copy', '--type', 'text/plain'},
    ['*'] = {'wl-copy', '--type', 'text/plain'},
  },
  paste = {
    ['+'] = {'wl-paste', '--type', 'text/plain'},
    ['*'] = {'wl-paste', '--type', 'text/plain'},
  }
}
vim.cmd[[ set clipboard+=unnamedplus ]]

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- Set highlight on search
vim.o.hlsearch = true

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

vim.o.mousemoveevent = true

vim.o.termguicolors = true

vim.o.expandtab = true

vim.o.cursorline = true
vim.o.foldcolumn = '1'

-- Set SidebarNvim current line highlight when focused
vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"*"},
  callback = function()
    local bufnr = tostring(vim.fn.bufnr())

    if vim.w['SavedBufView'] and vim.w['SavedBufView'][bufnr] then
      local v = vim.fn.winsaveview()
      local atStartOfFile = v.lnum == 1 and v.col == 0
      if atStartOfFile and vim.api.nvim_win_get_option(0, "diff") ~= true then
        vim.fn.winrestview(vim.w['SavedBufView'][bufnr])
      end

      local savedBufs = vim.w['SavedBufView']
      savedBufs[bufnr] =  nil
      vim.w['SavedBufView'] = savedBufs
    end
  end
})

vim.api.nvim_create_autocmd({"BufLeave"}, {
  pattern = {"*"},
  callback = function()
    local savedBufs = vim.w['SavedBufView']

    if savedBufs == nil then
      savedBufs = {}
    end
    local bufnr = vim.fn.bufnr()
    savedBufs[tostring(bufnr)] = vim.fn.winsaveview()
    vim.w['SavedBufView'] = savedBufs
  end
})
