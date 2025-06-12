return {
  {
    "ckyrouac/darcula-solid.nvim",
    cond = false,
    priority = 1000,
    dependencies = {
      "rktjmp/lush.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.cmd.colorscheme("darcula-solid")
    end,
  },
}
