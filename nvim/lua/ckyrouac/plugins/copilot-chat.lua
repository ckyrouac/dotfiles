return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = true,
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      context = "buffers",
      -- See Configuration section for rest
    },
    config = function()
      require("CopilotChat").setup {
        debug = false,
      }

      ---@diagnostic disable-next-line: lowercase-global
      function _openChatWindow()
        local chat = require("CopilotChat")
        chat.toggle({
          window = {
            layout = 'float',
            title = 'Copilot Chat',
            width = 0.8,
            height = 0.8,
          },
        })
      end

      vim.api.nvim_set_keymap('n', '<leader>sc', "<cmd>lua _openChatWindow()<CR>", {noremap = true, silent = true, desc = "Copilot Chat"})
    end,
  },
}
