return {
  {
    "akinsho/toggleterm.nvim",
    cond = true,
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      require("toggleterm").setup({
        size = 20,
      })

      local lazygit = Terminal:new({
        open_mapping = [[<A-3>]],
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        close_on_exit = true,
        float_opts = {
          border = "rounded",
        },
        on_open = function()
          vim.api.nvim_buf_set_keymap(0, "t", "<A-3>", [[q]], { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, "t", "<A-w>", [[q]], { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, "t", "<leader>og", [[q]], { noremap = true, silent = true })
        end,
      })

      ---@diagnostic disable-next-line: lowercase-global
      function _lazygit_toggle()
        lazygit.dir = vim.fn.getcwd()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap(
        "n",
        "<leader>og",
        "<cmd>lua _lazygit_toggle()<CR>",
        { noremap = true, silent = true, desc = "Git" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<A-3>",
        "<cmd>lua _lazygit_toggle()<CR>",
        { noremap = true, silent = true, desc = "Lazy Git Terminal" }
      )
    end,
  },
}
