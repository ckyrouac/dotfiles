return {
  {
    "stevearc/overseer.nvim",
    lazy = false,
    config = function()
      require("overseer").setup({
      local overseer = require("overseer")
      overseer.setup({
        dap = false, --patch dap in dap setup
      })

      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { silent = true, desc = "Overseer Tasks" })
    end,
  },
}
