return {
  {
    'ckyrouac/sidebar.nvim',
    config = function ()
      require("sidebar-nvim").setup({
        side = "right",
        initial_width = 50,
        hide_statusline = false,
        update_interval = 1000,
        section_separator = {"", "―――――――――――――――――――――――――――――――――――――――――――――", ""},
        sections = { "git", "diagnostics", "todos" },
        -- bindings = {["<2-LeftMouse>"] = function() require("sidebar-nvim").close() end }
      })

      vim.keymap.set('n', '<A-2>', ':SidebarNvimToggle<cr>')
    end
  }
}
