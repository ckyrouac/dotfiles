return {
  {
    "azorng/goose.nvim",
    config = function()
      require('goose').setup({
        prefered_picker = 'telescope',
        default_global_keymaps = false,
        keymap = {
          global = {
            toggle = '<leader>ag',                 -- Open goose. Close if opened 
              open_input = '<leader>ai',             -- Opens and focuses on input window on insert mode
              open_input_new_session = '<leader>aI', -- Opens and focuses on input window on insert mode. Creates a new session
              open_output = '<leader>ao',            -- Opens and focuses on output window 
              toggle_focus = '<leader>at',           -- Toggle focus between goose and last window
              close = '<leader>aq',                  -- Close UI windows
              toggle_fullscreen = '<leader>af',      -- Toggle between normal and fullscreen mode
              select_session = '<leader>as',         -- Select and load a goose session
              goose_mode_chat = '<leader>amc',       -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
              goose_mode_auto = '<leader>ama',       -- Set goose mode to `auto`. (Default mode with full agent capabilities)
              configure_provider = '<leader>ap',     -- Quick provider and model switch from predefined list
              diff_open = '<leader>ad',              -- Opens a diff tab of a modified file since the last goose prompt
              diff_next = '<leader>a]',              -- Navigate to next file diff
              diff_prev = '<leader>a[',              -- Navigate to previous file diff
              diff_revert_all = '<leader>ara',       -- Revert all file changes since the last goose prompt
              diff_revert_this = '<leader>art',      -- Revert current file changes since the last goose prompt
          },
          window = {
            submit = '<A-CR>',                     -- Submit prompt
            close = '<esc>',                     -- Close UI windows
            stop = '<C-c>',                      -- Stop goose while it is running
            next_message = ']]',                 -- Navigate to next message in the conversation
            prev_message = '[[',                 -- Navigate to previous message in the conversation
            mention_file = '@',                  -- Pick a file and add to context. See File Mentions section
            toggle_pane = '<tab>',               -- Toggle between input and output panes
            prev_prompt_history = '<up>',        -- Navigate to previous prompt in history
            next_prompt_history = '<down>'       -- Navigate to next prompt in history
          }
        },
        ui = {
          window_width = 0.66,                   -- Width as percentage of editor width
          input_height = 0.15,                   -- Input height as percentage of window height
          fullscreen = false,                    -- Start in fullscreen mode (default: false)
          layout = "center",                      -- Options: "center" or "right"
          floating_height = 0.9,                 -- Height as percentage of editor height for "center" layout
          display_model = true,                  -- Display model name on top winbar
          display_goose_mode = true              -- Display mode on top winbar: auto|chat
        },
        providers = {
          --[[
          Define available providers and their models for quick model switching
          anthropic|azure|bedrock|databricks|google|groq|ollama|openai|openrouter
          Example:
          openrouter = {
            "anthropic/claude-3.5-sonnet",
            "openai/gpt-4.1",
          },
          ollama = {
            "cogito:14b"
          }
          --]]
          -- gemini = {
          --   "gemini-2.5-pro-preview-05-06",
          -- },
        }
      })

    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
        },
      }
    },
  }
}
