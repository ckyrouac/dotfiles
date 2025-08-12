-- Disable netrw for nvim-tree
local utils = require("ckyrouac/utils")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- clipboard
vim.cmd([[ set clipboard+=unnamedplus ]])

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
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.mouse = "a"
vim.o.mousemoveevent = true
vim.o.mousem = "extend"

vim.o.termguicolors = true

vim.o.expandtab = true
vim.o.ts = 2

vim.o.cursorline = true
vim.o.splitkeep = "screen"

vim.o.shortmess = "filnxtToOFs"

-- bash
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Set SidebarNvim current line highlight when focused
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    local bufnr = tostring(vim.fn.bufnr())

    if vim.w["SavedBufView"] and vim.w["SavedBufView"][bufnr] then
      local v = vim.fn.winsaveview()
      local atStartOfFile = v.lnum == 1 and v.col == 0
      if atStartOfFile and vim.api.nvim_get_option_value("diff", { win = 0 }) ~= true then
        vim.fn.winrestview(vim.w["SavedBufView"][bufnr])
      end

      local savedBufs = vim.w["SavedBufView"]
      savedBufs[bufnr] = nil
      vim.w["SavedBufView"] = savedBufs
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
  pattern = { "*" },
  callback = function()
    local savedBufs = vim.w["SavedBufView"]

    if savedBufs == nil then
      savedBufs = {}
    end
    local bufnr = vim.fn.bufnr()
    savedBufs[tostring(bufnr)] = vim.fn.winsaveview()
    vim.w["SavedBufView"] = savedBufs
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = { "*" },
  callback = function()
    utils.dapui_refresh()
  end,
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  pattern = { "*" },
  callback = function()
    if utils.dapui_is_open() then
      require("dapui").close()
    end
  end,
})

vim.filetype.add({
  pattern = {
    [".*containerfile"] = "dockerfile",
  },
})

vim.opt.exrc = true
vim.opt.secure = true
vim.opt.laststatus = 3

vim.lsp.config.bashls = {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' }
}
vim.lsp.enable 'bashls'
