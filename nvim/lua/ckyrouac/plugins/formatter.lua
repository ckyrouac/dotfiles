return {
  {
    "mhartington/formatter.nvim",
    config = function()
      -- uncomment to enable global format on save
      --
      -- local augroup = vim.api.nvim_create_augroup
      -- local autocmd = vim.api.nvim_create_autocmd
      -- augroup("__formatter__", { clear = true })
      -- autocmd("BufWritePost", {
      --         group = "__formatter__",
      --         command = ":FormatWrite",
      -- })

      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = {
            function()
              local util = require("formatter.util")

              -- check for .stylelua.toml in project root, fall back to .stylelua.toml in dotfiles
              local args = {}
              if vim.fn.empty(vim.fn.glob(vim.fn.getcwd() .. "/.stylelua.toml")) then
                args = {
                  "--config-path",
                  "/home/chris/dotfiles/.stylelua.toml",
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                }
              else
                args = {
                  "--config-path",
                  vim.fn.getcwd() .. "/.stylelua.toml",
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                }
              end

              return {
                exe = "stylua",
                args = args,
                stdin = true,
              }
            end,
          },

          json = require("formatter.filetypes.json").prettier,
          rust = require("formatter.filetypes.rust").rustfmt,

          -- Use the special "*" filetype for defining formatter configurations on
          -- any filetype
          ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        },
      })

      vim.keymap.set("n", "<leader>cf", ":Format<CR>", { desc = "Format", silent = true })
    end,
  },
}
