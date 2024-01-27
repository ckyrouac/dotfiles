return {
  {
    "stevearc/overseer.nvim",
    lazy = false,
    config = function()
      local overseer = require("overseer").setup()

      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { silent = true, desc = "Overseer Tasks" })
    end,
  },
}
