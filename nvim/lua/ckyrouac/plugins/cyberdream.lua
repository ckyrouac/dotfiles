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
          }
        end,
      })
      vim.cmd.colorscheme("cyberdream")
    end,
  },
}
