return {
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        prompt_save_on_select_new_entry = false,
        view_options = {
          show_hidden = true,
        },
        float = {
          max_width = 80,
          override = function(conf)
            conf.anchor = 'NE'
            return conf
          end,
        },
      })

      vim.keymap.set("n", "<Leader>of", ":lua require('oil').toggle_float()<cr>", { silent = true, desc = "Oil files" })
      vim.keymap.set("n", "<A-2>", ":lua require('oil').toggle_float()<cr>", { silent = true, desc = "Oil files" })
    end,
  },
}
