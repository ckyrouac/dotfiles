return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = true,
    branch = "main",
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
        -- model = 'ibm/granite-8b-code-instruct',
        model = 'gemini-2.5-pro',
        -- providers = {
        --   watson = {
        --       prepare_input = function(inputs, opts)
        --         -- local body = {
        --         --   message = inputs,
        --         -- }
        --         -- local body = {
        --         --     message_payload = {
        --         --         "messages" = [
        --         --             {
        --         --                 "content" = "Write a program to add 2 numbers",
        --         --                 "role" = "USER",
        --         --             }
        --         --         ]
        --         --     }
        --         -- }
        --         --
        --         -- return body
        --       end,
        --
        --       prepare_output = function(output)
        --         local content = output.response.messages.content
        --
        --         return {
        --           content = content,
        --           finish_reason = "",
        --           total_tokens = "",
        --           references = "",
        --         }
        --       end,
        --
        --       get_headers = function()
        --           -- TODO: cache the key until it expires
        --           local api_key = assert(os.getenv('WCA_API_KEY'), 'WCA_API_KEY env not set')
        --
        --           local response, err = require('CopilotChat.utils').curl_post('https://iam.cloud.ibm.com/identity/token', {
        --               headers = {
        --                 ['Content-Type'] = 'application/x-www-form-urlencoded',
        --               },
        --               body = 'grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=' .. api_key,
        --               json_response = true,
        --           })
        --
        --           if err then
        --               error(err)
        --           end
        --
        --           print("token: " .. response.body.access_token)
        --
        --           return {
        --               Authorization = 'Bearer ' .. response.body.access_token,
        --               ['Content-Type'] = 'multipart/form-data',
        --           }
        --       end,
        --
        --       get_models = function()
        --           return {
        --             {
        --               id = "ibm/granite-8b-code-instruct",
        --               name = "ibm/granite-8b-code-instruct",
        --             }
        --           }
        --       end,
        --
        --       embed = require('CopilotChat.config.providers').copilot.embed,
        --
        --       get_url = function()
        --           return 'https://api.dataplatform.cloud.ibm.com/v2/wca/core/chat/text/generation'
        --       end,
        --   },
        -- },
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

      vim.api.nvim_set_keymap('n', '<leader>ac', "<cmd>lua _openChatWindow()<CR>", {noremap = true, silent = true, desc = "Copilot [C]hat"})
    end,
  },
}
