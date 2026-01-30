return {
  {
    "scottmckendry/cyberdream.nvim",
    cond = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        saturation = 0.8,
        hide_fillchars = false,
        borderless_pickers = false,
        highlights = {},
        overrides = function(colors)
          return {
            Visual = { bg = colors.blue, fg = colors.bg },
            ScrollbarHandle = { fg = "#ffffff", bg = "#2b2d30" },
            ScrollbarCursorHandle = { fg = "#2b2d30", bg = "#2b2d30" },
            ScrollbarCursor = { fg = "#000000", bg = "#000000" },
            DiagnosticError = { fg = colors.red },
            DiagnosticWarn = { fg = colors.orange },
            DiagnosticInfo = { fg = colors.yellow },
            DiagnosticHint = { fg = colors.cyan },
            DiagnosticErrorAlt = { fg = colors.red },
            DiagnosticWarnAlt = { fg = colors.orange },
            DiagnosticInfoAlt = { fg = colors.yellow },
            DiagnosticHintAlt = { fg = colors.cyan },
            BufferLineHintDiagnosticVisible = { fg = colors.cyan },
            BufferLineHintDiagnostic = { fg = colors.cyan },
            BufferLineHintVisible = { fg = colors.comment },
            BufferLineHint = { fg = colors.comment },
            BufferLineInfoDiagnosticVisible = { fg = colors.yellow_alt },
            BufferLineInfoDiagnostic = { fg = colors.yellow_alt },
            BufferLineInfo = { fg = colors.comment },
            BufferLineInfoVisible = { fg = colors.comment },
            BufferLineWarningDiagnosticVisible = { fg = colors.orange },
            BufferLineWarningDiagnostic = { fg = colors.orange },
            BufferLineWarning = { fg = colors.comment },
            BufferLineWarningVisible = { fg = colors.comment },
            BufferLineErrorDiagnosticVisible = { fg = colors.red },
            BufferLineErrorDiagnostic = { fg = colors.red },
            BufferLineError = { fg = colors.comment },
            BufferLineErrorVisible = { fg = colors.comment },
            DiffAdd = { bg = "#1a3d2e" },
            DiffDelete = { bg = "#3d1a1a" },
            DiffChange = { bg = "#1a2d3d" },
            DiffText = { bg = "#2a4d5d" },
            DiffAdded = { fg = colors.green },
            DiffRemoved = { fg = colors.red },
            yamlPlainScalar = { fg = colors.green },
            yamlBlockString = { fg = colors.green },
            yamlBlockScalarHeader = { fg = colors.green },
            yamlBool = { fg = colors.cyan },
          }
        end,
      })
      vim.cmd.colorscheme("cyberdream")

      -- Dim background when pane loses focus (for tmux integration)
      local colors = require("cyberdream.colors").default
      local dim_bg = "#101214"

      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = dim_bg, fg = colors.fg })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = dim_bg, fg = colors.fg })
        end,
      })

      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = colors.bg, fg = colors.fg })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = colors.bg, fg = colors.fg })
        end,
      })
    end,
  },
}
