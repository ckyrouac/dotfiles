-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Pane navigation keybinds
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<c-h>', '<c-w>h')


-- Buffer navigation keybinds
vim.keymap.set('n', '{', ':bp<cr>')
vim.keymap.set('n', '}', ':bn<cr>')
vim.keymap.set('n', 'w', ':SmartQ<cr>')
vim.keymap.set('n', 'W', ':Bdelete other<cr>')
vim.keymap.set('n', '<M-C-W>', ':SmartQCloseSplits<cr>')

-- clear search highlight
vim.keymap.set('n', '<leader>c', ':noh<CR>', { desc = 'Clear search highlight' })

-- quickly quit
vim.keymap.set('n', '<C-q>', ':q<CR>', { desc = 'Quickly quit via escape :q' })
