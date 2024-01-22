vim.keymap.set("n", "<RightMouse>", "<LeftMouse><LeftRelease><cmd>:popup MainContextMenu<CR>", { silent = true })
vim.keymap.set("n", "<A-k>", "<cmd>:popup MainContextMenu<CR>", { silent = true })

-- Main Menu
vim.cmd([[:amenu 10.100 MainContextMenu.Definition <cmd>:Telescope lsp_definitions<CR>]])
vim.cmd([[:amenu 10.110 MainContextMenu.Peek\ Definition <cmd>:Lspsaga peek_definition<CR>]])
vim.cmd([[:amenu 10.120 MainContextMenu.Type\ Definition <cmd>:Telescope lsp_type_definitions<CR>]])
vim.cmd([[:amenu 10.130 MainContextMenu.Implementations <cmd>:Telescope lsp_implementations<CR>]])
vim.cmd([[:amenu 10.140 MainContextMenu.References <cmd>:Telescope lsp_references<CR>]])
vim.cmd([[:amenu 10.150 MainContextMenu.References <cmd>:Telescope lsp_references<CR>]])
-- vim.cmd [[:amenu 10.160 MainContextMenu.Rename <cmd>:Lspsaga rename<CR>]]
-- vim.cmd [[:amenu 10.170 MainContextMenu.Code\ Actions <cmd>:Lspsaga code_action<CR>]]
-- vim.cmd [[:amenu 10.180 MainContextMenu.-ActionsSeparator- *]]
vim.cmd([[:amenu 10.190 MainContextMenu.Git\ → <cmd>:popup Git<CR>]])
vim.cmd([[:amenu 10.200 MainContextMenu.Toggle\ Diagnostics <cmd>:lua if vim.diagnostic.is_disabled() then vim.diagnostic.enable() else vim.diagnostic.disable() end<CR>]])

-- Git Sub Menu
vim.cmd([[:amenu 20.100 Git.Stage\ Buffer <cmd>:Gitsigns stage_buffer<CR>]])
vim.cmd([[:amenu 20.110 Git.Reset\ Buffer <cmd>:Gitsigns reset_buffer<CR>]])
vim.cmd([[:amenu 20.120 Git.-GitBufferSeparator- *]])

vim.cmd([[:amenu 20.130 Git.Stage\ Hunk <cmd>:Gitsigns stage_hunk<CR>]])
vim.cmd([[:amenu 20.140 Git.Undo\ Stage\ Hunk <cmd>:Gitsigns undo_stage_hunk<CR>]])
vim.cmd([[:amenu 20.150 Git.Preview\ Hunk <cmd>:Gitsigns preview_hunk<CR>]])
vim.cmd([[:amenu 20.160 Git.Reset\ Hunk <cmd>:Gitsigns reset_hunk<CR>]])
vim.cmd([[:amenu 20.170 Git.-GitHunkSeparator- *]])

vim.cmd([[:amenu 20.180 Git.Blame\ Line <cmd>:Gitsigns blame_line<CR>]])
vim.cmd([[:amenu 20.190 Git.Diff <cmd>:Gitsigns diffthis<CR>]])
vim.cmd([[:amenu 20.180 Git.-GitDiffSeparator- *]])
vim.cmd([[:amenu 20.190 Git.Toggle\ Blame <cmd>:Gitsigns toggle_current_line_blame<CR>]])
vim.cmd([[:amenu 20.200 Git.Toggle\ Deleted <cmd>:Gitsigns toggle_deleted<CR>]])
vim.cmd([[:amenu 20.210 Git.-GitSeparator- *]])
