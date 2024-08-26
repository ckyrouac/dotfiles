return {
  {
    -- Set lualine as statusline
    cond = true,
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    opts = {
      options = {
        component_separators = "|",
        section_separators = "",
      },
    },
    config = function()
      -- lualine status for recording macros
      -- https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?utm_source=reddit&utm_medium=web2x&context=3
      local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
          return ""
        else
          return "Recording @" .. recording_register
        end
      end


      local function get_workspace_error_count()
        local errors = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
        return #errors
      end

      local function get_workspace_warn_count()
        local errors = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
        return #errors
      end

      local function get_workspace_info_count()
        local errors = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.INFO })
        return #errors
      end

      local function get_workspace_hint_count()
        local errors = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.HINT })
        return #errors
      end

      local lualine = require("lualine")
      lualine.setup({
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},

        sections = {
          lualine_a = { "filename" },
          lualine_b = {
            "branch",
            "diff",
            {
              "diagnostics",
              on_click = function()
                vim.cmd [[
                  Trouble diagnostics toggle focus=true filter.buf=0
                ]]
                vim.lsp.diagnostic.show_line_diagnostics()
              end,
            },
          },
          lualine_c = {
            {
              "macro-recording",
              fmt = show_macro_recording,
            },
          },
          lualine_x = {
            {
              get_workspace_error_count,
              color = { fg = "#F75464" },
              icon = '󰅚',
              cond = function ()
                return get_workspace_error_count() > 0
              end,
              on_click = function()
                vim.cmd [[
                  Trouble diagnostics toggle focus=true
                ]]
                vim.lsp.diagnostic.show_line_diagnostics()
              end,
            },
            {
              get_workspace_warn_count,
              color = { fg = "#CF8E6D" },
              icon = '󰀪',
              cond = function ()
                return get_workspace_warn_count() > 0
              end,
              on_click = function()
                vim.cmd [[
                  Trouble diagnostics toggle focus=true
                ]]
                vim.lsp.diagnostic.show_line_diagnostics()
              end,
            },
            {
              get_workspace_info_count,
              color = { fg = "#AFBF7E" },
              icon = '💡',
              cond = function ()
                return get_workspace_info_count() > 0
              end,
              on_click = function()
                vim.cmd [[
                  Trouble diagnostics toggle focus=true
                ]]
                vim.lsp.diagnostic.show_line_diagnostics()
              end,
            },
            {
              color = { fg = "#ffffff" },
              get_workspace_hint_count,
              icon = '🛈',
              cond = function ()
                return get_workspace_hint_count() > 0
              end,
              on_click = function()
                vim.cmd [[
                  Trouble diagnostics toggle focus=true
                ]]
                vim.lsp.diagnostic.show_line_diagnostics()
              end,
            },
            "filetype",
          },
          lualine_y = { "location" },
          lualine_z = { "mode" },
        },
        options = {
          theme = require("darcula-solid.lualine_theme"),
          disabled_filetypes = {
            "NvimTree",
            "SidebarNvim",
            "dapui_watches",
            "dapui_stacks",
            "dapui_breakpoints",
            "dapui_scopes",
            "dapui_console",
            "dap-repl",
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })

      -- instantly update lualine when entering recording
      vim.api.nvim_create_autocmd("RecordingEnter", {
        callback = function()
          lualine.refresh({
            place = { "statusline" },
          })
        end,
      })

      vim.api.nvim_create_autocmd("RecordingLeave", {
        callback = function()
          -- This is going to seem really weird!
          -- Instead of just calling refresh we need to wait a moment because of the nature of
          -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
          -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
          -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
          -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
          local timer = vim.loop.new_timer()
          timer:start(
            50,
            0,
            vim.schedule_wrap(function()
              lualine.refresh({
                place = { "statusline" },
              })
            end)
          )
        end,
      })
    end,
  },
}
