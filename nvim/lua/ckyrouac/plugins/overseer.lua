return {
  {
    "stevearc/overseer.nvim",
    cond = true,
    lazy = false,
    config = function()
      require("overseer").setup()
      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { silent = true, desc = "Overseer Tasks" })
    end,
  },
}
