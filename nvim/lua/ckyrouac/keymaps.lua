--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- remove default mappings that conflict
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
-- vim.keymap.del("n", "<C-W>d")
-- vim.keymap.del("n", "<C-W><C-D>")

-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

local function prev_diagnostic()
  vim.diagnostic.jump({ count = -1, float = true })
end

local function next_diagnostic()
  vim.diagnostic.jump({ count = 1, float = true })
end

-- Diagnostic keymaps
vim.keymap.set("n", "[d", prev_diagnostic, { desc = "Go to previous diagnostic message", silent = true })
vim.keymap.set("n", "]d", next_diagnostic, { desc = "Go to next diagnostic message", silent = true })

-- Pane navigation keybinds
vim.keymap.set("n", "<c-j>", "<c-w>j", { silent = true, desc = "Bottom pane" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { silent = true, desc = "Top pane" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { silent = true, desc = "Right pane" })
vim.keymap.set("n", "<c-h>", "<c-w>h", { silent = true, desc = "Left pane" })

-- remap macro
vim.keymap.set("n", "<leader>q", "q", { silent = true, desc = "Record macro" })

-- Buffer navigation keybinds
vim.keymap.set("n", "{", ":bp<cr>", { silent = true, desc = "Left buffer" })
vim.keymap.set("n", "}", ":bn<cr>", { silent = true, desc = "Right buffer" })
vim.keymap.set("n", "<C-w>", "<Plug>(smartq_this)", { silent = true, desc = "Close current buffer" })
-- Smart close function that handles Diffview
local function smart_close()
  if next(require('diffview.lib').views) == nil then
    vim.cmd("SmartQ")
  else
    vim.cmd("DiffviewClose")
  end
end

vim.keymap.set("n", "q", smart_close, { silent = true, desc = "Smart close" })
vim.keymap.set("n", "<M-w>", "<Plug>(smartq_this)", { silent = true, desc = "Close current buffer" })
vim.keymap.set("n", "W", ":Bdelete other<cr>", { silent = true, desc = "Close other buffers" })
vim.keymap.set("n", "<M-C-W>", ":SmartQCloseSplits<cr>", { silent = true, desc = "Close other splits" })

vim.keymap.set("n", "<M-C-Q>", ":wqa!<CR>", { desc = "Quit and save everything", silent = true })
vim.keymap.set("n", "<leader>i", ":Inspect<CR>", { desc = "Inspect", silent = true })

-- preserve clipbaord when deleting
vim.keymap.set("n", "d", '"_d', { silent = true })
vim.keymap.set("v", "d", '"_d', { silent = true })
vim.keymap.set("n", "D", '"_D', { silent = true })

-- toggle inlay hints
local function toggle_inlay_hints()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end

vim.keymap.set("n", "<leader>k", toggle_inlay_hints, { silent = true, desc = "Toggle inlay hints" })

-- paste in insert mode
vim.keymap.set("i", "<C-S-V>", "<c-r>+", { silent = true, desc = "Paste in insert mode" })

local function toggle_line_numbers()
  if vim.o.rnu then
    vim.o.rnu = false
  else
    vim.o.rnu = true
  end
end
vim.keymap.set("n", "<leader>l", toggle_line_numbers, { silent = true, desc = "Toggle relative line numbers" })

-- mouse forward/back
-- vim.keymap.set('n', '<X1Mouse>', '<C-i>', { silent = true, desc = 'Toggle relative line numbers' })
-- vim.keymap.set('n', '<X2Mouse>', '<C-o>', { silent = true, desc = 'Toggle relative line numbers' })

-- folds
vim.keymap.set("n", "<leader>z", "za", { desc = "Toggle fold", noremap = true })
