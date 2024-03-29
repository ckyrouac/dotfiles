return {
  "folke/which-key.nvim",
  opts = {},
  cond = true,
  config = function()
    require("which-key").setup({
      icons = {
        group = "",
      },
    })

    -- normal chains
    require("which-key").register({
      ["<leader>c"] = { name = "Code", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "Dap", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "Git", _ = "which_key_ignore" },
      ["<leader>r"] = { name = "Rename", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "Search", _ = "which_key_ignore" },
      ["<leader>w"] = { name = "Workspace", _ = "which_key_ignore" },
      ["<leader>p"] = { name = "Projects", _ = "which_key_ignore" },
      ["<leader>o"] = { name = "Open Tool", _ = "which_key_ignore" },
      ["<leader>x"] = { name = "Close", _ = "which_key_ignore" },
      ["<leader>m"] = { name = "Markdown", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "Find", _ = "which_key_ignore" },

      -- dap chains
      ["<leader>ds"] = { name = "Steps", _ = "which_key_ignore" },
      ["<leader>dh"] = { name = "Hover", _ = "which_key_ignore" },
      ["<leader>du"] = { name = "Widgets", _ = "which_key_ignore" },
      ["<leader>dr"] = { name = "REPL", _ = "which_key_ignore" },
      ["<leader>db"] = { name = "Breakpoints", _ = "which_key_ignore" },

      -- git chains
      ["<leader>gt"] = { name = "Toggle", _ = "which_key_ignore" },
    })

    -- visual chains
    require("which-key").register({
      -- dap chains
      ["<leader>d"] = { "Dap" },
      ["<leader>dh"] = { "Hover" },

      -- git chains
      ["<leader>g"] = { "Git" },
    }, { mode = "v" })
  end,
}
