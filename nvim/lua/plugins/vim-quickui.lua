return {
  {
    'skywind3000/vim-quickui',
    init = function ()
     -- Add some config to run BEFORE plugin/quickui.vim loads
     vim.g.quickui_border_style = 2
    end,
    config = function ()
     -- Add some config AFTER plugin/quickui.vim has been loaded
     vim.cmd [[ hi! QuickPreview guibg=red ]]
    end,
  }
}
