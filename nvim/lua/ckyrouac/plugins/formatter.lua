return {
  {
    "mhartington/formatter.nvim",
    config = function()
      -- format on save
      -- local augroup = vim.api.nvim_create_augroup
      -- local autocmd = vim.api.nvim_create_autocmd
      -- augroup("__formatter__", { clear = true })
      -- autocmd("BufWritePost", {
      --         group = "__formatter__",
      --         command = ":FormatWrite",
      -- })

      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      require("formatter").setup({
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- All formatter configurations are opt-in
        filetype = {
          -- Formatter configurations for filetype "lua" go here
          -- and will be executed in order
          lua = {
            -- require("formatter.filetypes.lua").stylua,
            function()
              -- Supports conditional formatting
              -- if util.get_current_buffer_file_name() == "special.lua" then
              -- 	return nil
              -- end

              local util = require("formatter.util")
              return {
                exe = "stylua",
                args = {
                  "--config-path",
                  vim.fn.getcwd() .. "/.stylelua.toml",
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end,
          },

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
