return {
  {
    'sidebar-nvim/sidebar.nvim',
    config = function ()
      require("sidebar-nvim").setup({
        side = "left",
        initial_width = 50,
        hide_statusline = false,
        update_interval = 1000,
        section_separator = {"", "―――――――――――――――――――――――――――――――――――――――――――――", ""},
        sections = { "git", "diagnostics", "todos" },
      })

      vim.keymap.set('n', '<A-2>', ':SidebarNvimToggle<cr>')
    end
  }
}
