return {
  {
    'milanglacier/minuet-ai.nvim',
    cond = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function ()
      require('minuet').setup {
        provider = 'openai_fim_compatible',
        provider_options = {
          openai_fim_compatible = {
            model = 'qwen2.5-coder:7b',
            end_point = 'http://localhost:11434/v1/completions',
            api_key = function() return 'sk-xxxx' end,
            stream = false,
            name = 'Mistral',
          },
        },
        request_timeout = 10,
        context_window = 768,
        virtualtext = {
          auto_trigger_ft = {'rust', 'lua', 'bash'},
          keymap = {
            -- accept whole completion
            accept = '<A-a>',
            -- accept one line
            accept_line = '<A-y>',
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = '<A-z>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = '<A-[>',
            -- Cycle to next completion item, or manually invoke completion
            next = '<A-]>',
            dismiss = '<A-e>',
          },
        },
      }
      --
      -- llm.setup({
      --   api_token = nil, -- cf Install paragraph
      --   model = "granite-code:8b", -- the model ID, behavior depends on backend
      --   backend = "ollama", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
      --   url = "http://localhost:11434", -- the http url of the backend
      --   request_body = {
      --     options = {
      --       temperature = 0.2,
      --       top_p = 0.95,
      --     }
      --   },
      --   accept_keymap = "<C-y>",
      --   tls_skip_verify_insecure = true,
      --   context_window = 5000, -- max number of tokens for the context window
      --   enable_suggestions_on_startup = true,
      --   enable_suggestions_on_files = "*.lua", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
      -- })
    end,
  },
}
