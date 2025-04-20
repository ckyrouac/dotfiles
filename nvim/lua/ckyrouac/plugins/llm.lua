return {
  {
    'huggingface/llm.nvim',
    cond = false,
    opts = {
      -- cf Setup
    },
    config = function ()
      local llm = require('llm')

      llm.setup({
        api_token = nil, -- cf Install paragraph
        model = "granite-code:8b", -- the model ID, behavior depends on backend
        backend = "ollama", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
        url = "http://localhost:11434", -- the http url of the backend
        request_body = {
          options = {
            temperature = 0.2,
            top_p = 0.95,
          }
        },
        accept_keymap = "<C-y>",
        tls_skip_verify_insecure = true,
        context_window = 5000, -- max number of tokens for the context window
        enable_suggestions_on_startup = true,
        enable_suggestions_on_files = "*.lua", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
      })
    end,
  },
}
