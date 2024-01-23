return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local colors = require('darcula-solid.colors')
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, level)
            local signs = require('darcula-solid.diagnostics').Signs

            if level:match("error") then
              return signs.Error
            elseif level:match("warn") then
              return signs.Warn
            elseif level:match("hint") then
              return signs.Hint
            elseif level:match("info") then
              return signs.Info
            end

          end,
          close_command = "SmartQ %d",
          offsets = {
            {
              padding = 0,
              filetype = "NvimTree",
              text = "🗄File Explorer",
              text_align = "left",
              highlight = "Normal",
              separator = true,
            },
            {
              padding = 0,
              filetype = "SidebarNvim",
              text = "💁 Sidebar",
              text_align = "left",
              highlight = "Normal",
              separator = true,
            },
          },
        },
        highlights = {
          background = {
            bg = colors.bg,
          },
          error = {
            fg = colors.comment,
            bg = colors.bg,
          },
          error_visible = {
            fg = colors.comment,
            bg = colors.bg,
          },
          error_selected = {
            fg = colors.fg,
            bg = colors.bg,
          },
          -- warning = {
          --   fg = colors.fg,
          --   bg = colors.bg,
          -- },
          warning_visible = {
            fg = colors.comment,
            bg = colors.bg,
          },
          warning_selected = {
            fg = colors.fg,
            bg = colors.bg,
          }
        },
      })
    end,
  },
}
