--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message", silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message", silent = true })

-- Pane navigation keybinds
vim.keymap.set("n", "<c-j>", "<c-w>j", { silent = true, desc = "Bottom pane" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { silent = true, desc = "Top pane" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { silent = true, desc = "Right pane" })
vim.keymap.set("n", "<c-h>", "<c-w>h", { silent = true, desc = "Left pane" })

-- Buffer navigation keybinds
vim.keymap.set("n", "{", ":bp<cr>", { silent = true, desc = "Left buffer" })
vim.keymap.set("n", "}", ":bn<cr>", { silent = true, desc = "Right buffer" })
vim.keymap.set("n", "w", "<Plug>(smartq_this)", { silent = true, desc = "Close current buffer" })
vim.keymap.set("n", "W", ":Bdelete other<cr>", { silent = true, desc = "Close other buffers" })
vim.keymap.set("n", "<M-C-W>", ":SmartQCloseSplits<cr>", { silent = true, desc = "Close other splits" })

-- vim.keymap.set("n", "<C-q>", "<Plug>(smartq_this)", { silent = true, desc = "Close current buffer" })

vim.keymap.set("n", "<M-C-Q>", ":wqa!<CR>", { desc = "Quit and save everything", silent = true })
vim.keymap.set("n", "<leader>i", ":Inspect<CR>", { desc = "Inspect", silent = true })

-- preserve clipbaord when deleting
vim.keymap.set("n", "d", '"_d', { silent = true })
vim.keymap.set("v", "d", '"_d', { silent = true })
vim.keymap.set("n", "D", '"_D', { silent = true })

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
