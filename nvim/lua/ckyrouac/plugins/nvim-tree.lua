return {
  {
    'nvim-tree/nvim-tree.lua',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require("nvim-tree").setup({
          sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 50,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })

      vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<cr>')
      vim.keymap.set('n', '<A-1>', ':NvimTreeToggle<cr>')
    end
  }
}
