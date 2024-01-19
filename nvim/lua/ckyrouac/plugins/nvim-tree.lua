return {
  {
    'nvim-tree/nvim-tree.lua',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false,
    config = function ()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        actions = {
          change_dir = {
            enable = false,
          },
        },
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
        hijack_cursor = true
      })

      vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<cr>', {silent = true})
      vim.keymap.set('n', '<A-1>', ':NvimTreeToggle<cr>', {silent = true})

      -- restore nvimtree on startup if vim exited with nvimtree open
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = 'NvimTree*',
        callback = function()
          local view = require('nvim-tree.view')
          local is_visible = view.is_visible()

          local api = require('nvim-tree.api')
          if not is_visible then
            api.tree.open()
          end
        end,
      })

      -- use this to never open nvimtree on startup
      -- https://github.com/nvim-tree/nvim-tree.lua/issues/1992
      --
      -- vim.api.nvim_create_autocmd('FileType', {
      --   pattern = { 'NvimTree' },
      --   callback = function(args)
      --     vim.api.nvim_create_autocmd('VimLeavePre', {
      --       callback = function()
      --         vim.api.nvim_buf_delete(args.buf, { force = true })
      --         return true
      --       end
      --     })
      --   end,
      -- })
      --
    end
  }
}
