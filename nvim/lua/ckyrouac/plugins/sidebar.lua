return {
  {
    "ckyrouac/sidebar.nvim",
    cond = false,
    config = function()
      require("sidebar-nvim").setup({
        side = "right",
        initial_width = 50,
        hide_statusline = false,
        update_interval = 1000,
        section_separator = {
          "",
          "―――――――――――――――――――――――――――――――――――――――――――――",
          "",
        },
        sections = { "git", "diagnostics", "todos" },
      })

      -- vim.keymap.set("n", "<A-2>", ":SidebarNvimToggle<cr>", { silent = true })
    end,
  },
}
