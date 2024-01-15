-- Override plugin colors here. This is loaded last.
vim.cmd [[ hi! Search guifg=#a0a0a0 guibg=#505052 ]]
vim.cmd [[ hi! CurSearch guifg=#505052 guibg=#a0a0a0 ]]


vim.api.nvim_create_autocmd({"BufEnter","FocusGained","WinEnter"}, {
  pattern = {"*NvimTree*"},
  callback = function()
    vim.cmd [[ hi! NvimTreeNormal guibg=#262627 ]]
  end
})

vim.api.nvim_create_autocmd({"BufLeave","FocusLost","WinLeave"}, {
  pattern = {"*NvimTree*"},
  callback = function()
    vim.cmd [[ hi! NvimTreeNormal guibg=#232324 ]]
  end
})
