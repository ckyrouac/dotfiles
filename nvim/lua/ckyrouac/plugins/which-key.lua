return {
  "folke/which-key.nvim",
  opts = {},
  config = function()
    require("which-key").setup({
      icons = {
        group = "",
      },
    })

    -- document existing key chains
    require("which-key").register({
      ["<leader>c"] = { name = "Code", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "Dap", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "Git", _ = "which_key_ignore" },
      ["<leader>h"] = { name = "Git Hunk", _ = "which_key_ignore" },
      ["<leader>r"] = { name = "Rename", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "Search", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "Toggle", _ = "which_key_ignore" },
      ["<leader>w"] = { name = "Workspace", _ = "which_key_ignore" },

      -- dap chains
      ["<leader>ds"] = { name = "Steps", _ = "which_key_ignore" },
      ["<leader>dh"] = { name = "Hover", _ = "which_key_ignore" },
      ["<leader>du"] = { name = "Widgets", _ = "which_key_ignore" },
      ["<leader>dr"] = { name = "REPL", _ = "which_key_ignore" },
      ["<leader>db"] = { name = "Breakpoints", _ = "which_key_ignore" },
    })
    -- register which-key VISUAL mode
    -- required for visual <leader>hs (hunk stage) to work
    require("which-key").register({
      ["<leader>"] = { name = "VISUAL <leader>" },
      ["<leader>h"] = { "Git [H]unk" },
    }, { mode = "v" })
  end,
}
