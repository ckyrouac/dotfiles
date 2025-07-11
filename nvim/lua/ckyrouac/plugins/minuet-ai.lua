return {
  {
    "milanglacier/minuet-ai.nvim",
    cond = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("minuet").setup({
        cmp = {
          enable_auto_complete = false,
        },
        blink = {
          enable_auto_complete = false,
        },
        provider = "gemini",
        context_window = 20000,
        request_timeout = 4,
        throttle = 3000,
        debounce = 1000,
        n_completions = 1,
        provider_options = {
          gemini = {
            api_key = "GEMINI_API_KEY",
            model = "gemini-2.5-flash",
            optional = {
              generationConfig = {
                maxOutputTokens = 256,
                -- When using `gemini-2.5-flash`, it is recommended to entirely
                -- disable thinking for faster completion retrieval.
                thinkingConfig = {
                  thinkingBudget = 0,
                },
              },
              safetySettings = {
                {
                  category = "HARM_CATEGORY_DANGEROUS_CONTENT",
                  threshold = "BLOCK_ONLY_HIGH",
                },
              },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          auto_trigger_ignore_ft = {},
          keymap = {
            -- accept whole completion
            accept = "<C-y>",
            -- accept one line
            accept_line = "<A-a>",
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = "<A-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },
        },
      })
    end,
  },
}
