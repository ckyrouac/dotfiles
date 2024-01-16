-- Override plugin colors here. This is loaded last.
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
