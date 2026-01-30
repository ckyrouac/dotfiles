return {
  {
    "mrcjkb/rustaceanvim",
    -- Use local development version with CLI diagnostics fallback
    dir = "~/projects/rustaceanvim",
    cond = true,
    lazy = false,
    ft = { "rust" },
    config = function()
      -- Add keymap for CLI diagnostics fallback (useful when rust-analyzer LSP fails)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(ev)
          vim.keymap.set("n", "<leader>cd", function()
            vim.cmd("RustLsp cliDiagnostics run")
          end, { buffer = ev.buf, desc = "Run CLI diagnostics", silent = true, noremap = true })
        end,
      })
    end,
  },
}
