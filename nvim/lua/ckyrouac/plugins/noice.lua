return {
  {
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {},
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      config = function()
        require("noice").setup({
          routes = {
            {
              -- view = "notify",
              -- view = "popup",
              -- view = "messages",
              view = "mini",
              filter = {
                event = "msg_show",
                kind = "echo",
              },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "lines yanked",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "written",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "search_count",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "fewer lines;",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "fewer lines",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "more lines",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "more line;",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "line less;",
              },
              opts = { skip = true },
            },
            {
              filter = {
                event = "msg_show",
                kind = "",
                find = "change;",
              },
              opts = { skip = true },
            },
          },
          messages = {
            enabled = true, -- enables the Noice messages UI
            view = "mini", -- default view for messages
            view_error = "notify", -- view for errors
            view_warn = "notify", -- view for warnings
            view_history = "messages", -- view for :messages
            view_search = "virtualtext",
          },
          lsp = {
            hover = {
              enabled = true,
            },
            progress = {
              enabled = false,
            },
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
          presets = {
            bottom_search = true,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = true,
            lsp_doc_border = true,
          },
        })

        require("notify").setup({
          top_down = false,
        })
      end,
    },
  },
}
