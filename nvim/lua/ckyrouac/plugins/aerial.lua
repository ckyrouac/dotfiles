return {
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
    config = function ()
      require("aerial").setup({
        layout = {
          width = 50,
        },
      })
      vim.keymap.set("n", "<leader>fa", "<cmd>AerialToggle! right<CR>", { desc = "Toggle Aerial" })
    end
  }
}
