return {
  {
    cond = true,
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust"),
        },
      })

      vim.api.nvim_set_keymap(
        "n",
        "<leader>tl",
        "<cmd>lua require('neotest').run.run_last()<CR>",
        { noremap = true, silent = true, desc = "Run last" }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>tt",
        "<cmd>lua require('neotest').run.run({stdout = true})<CR>",
        { noremap = true, silent = true, desc = "Run nearest" }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>tf",
        "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
        { noremap = true, silent = true, desc = "Run current file" }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>td",
        "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
        { noremap = true, silent = true, desc = "Debug current file" }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>tw",
        "<cmd>lua require('neotest').output.open({ enter = true, auto_close = true })<CR>",
        { noremap = true, silent = true, desc = "Output window" }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>too",
        "<cmd>lua require('neotest').output_panel.toggle()<CR>",
        { noremap = true, silent = true, desc = "Toggle output panel" }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>toc",
        "<cmd>lua require('neotest').output_panel.clear()<CR>",
        { noremap = true, silent = true, desc = "Clear output panel" }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>ts",
        "<cmd>lua require('neotest').summary.toggle()<CR>",
        { noremap = true, silent = true, desc = "Toggle summary" }
      )

    end,
  },
}
