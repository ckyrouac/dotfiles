return {
  {
    "akinsho/toggleterm.nvim",
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
        end,
      })

      ---@diagnostic disable-next-line: lowercase-global
      function _lazygit_toggle()
        lazygit.dir = vim.fn.getcwd()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap("n", "<A-3>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

      -- dropdown
      local dropdown = Terminal:new({
        hidden = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        direction = "float",
        shell = vim.o.shell,
        name = "dropdown",
        on_open = function()
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(
            0,
            "t",
            "<A-w>",
            [[<C-\><C-o>:lua _dropdown_toggle()<cr>]],
            { noremap = true, silent = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "t",
            "<A-4>",
            [[<C-\><C-o>:lua _dropdown_toggle()<cr>]],
            { noremap = true, silent = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "t",
            "<esc><esc>",
            [[<C-\><C-o>:lua _dropdown_toggle()<cr>]],
            { noremap = true, silent = true }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "t",
            "<leader>t",
            [[<C-\><C-o>:lua _dropdown_toggle()<cr>]],
            { noremap = true, silent = true }
          )
        end,
      })

      ---@diagnostic disable-next-line: lowercase-global
      function _dropdown_toggle()
        dropdown:toggle()
      end

      vim.api.nvim_set_keymap("n", "<A-4>", "<cmd>lua _dropdown_toggle()<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>lua _dropdown_toggle()<CR>", { silent = true })
    end,
  },
}
