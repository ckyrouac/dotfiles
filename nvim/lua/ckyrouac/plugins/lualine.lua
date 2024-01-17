return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },
    config = function ()
      -- lualine theme
      local lualine_theme = require'lualine.themes.auto'
      lualine_theme.normal.c.bg = '#2b2d30'
      lualine_theme.insert.c.bg = '#292929'
      lualine_theme.visual.c.bg = '#2b2d30'
      lualine_theme.command.c.bg = '#2b2d30'

      require('lualine').setup {
        options = {
          theme  = lualine_theme ,
          disabled_filetypes = { 'NvimTree', 'SidebarNvim' },
        },
      }
    end
  }
}
