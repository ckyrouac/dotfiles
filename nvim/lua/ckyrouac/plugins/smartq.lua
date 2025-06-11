return {
  {
    "marklcrns/vim-smartq",
    cond = true,
    init = function()
      vim.g.smartq_default_mappings = 0
      vim.g.smartq_exclude_filetypes = {'fugitive'}
      vim.g.smartq_no_exit = 1
      vim.g.smartq_auto_close_splits = 1
    end,
    config = function() end,
  },
}
