-- See `:help telescope` and `:help telescope.setup()`

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          prompt_prefix = '🔎 ',
          selection_caret = '  ',
          sorting_strategy = 'ascending',
          layout_config = {
            vertical = {
              height = 0.9,
              width = 0.5,
              prompt_position = 'top',
              previewer = true,
              mirror = true,
              preview_height = 0.5,
              preview_cutoff = 25,
            },
            horizontal = {
              prompt_position = 'top',
            },
          }
        },
        pickers = {
          ['neovim-project'] = {
            layout_strategy = 'vertical'
          },
          lsp_definitions = {
            theme = "cursor",
            previewer = false,
          },
          lsp_references = {
            layout_strategy = 'vertical',
            show_line = false,
          },
          lsp_implementations = {
            theme = "cursor",
            previewer = false,
          },
          current_buffer_fuzzy_find = {
            layout_strategy = 'vertical',
          },
          find_files = {
            layout_strategy = 'vertical',
          },
          live_grep = {
            layout_strategy = 'vertical',
          },
          oldfiles = {
            layout_strategy = 'vertical',
          },
          git_files = {
            layout_strategy = 'vertical',
          },
          buffers = {
            layout_strategy = 'vertical',
          },
          help_tags = {
            layout_strategy = "vertical",
          },
          grep_string = {
            layout_strategy = "vertical",
          },
          diagnostics = {
            layout_strategy = "vertical",
          },
          resume = {
            layout_strategy = "vertical",
          },
          keymaps = {
            layout_strategy = "vertical",
          },
        },
        extensions = {
          ["ui-select"] = {
            -- require("telescope.themes").get_dropdown {
            --   -- even more opts
            -- }
            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
          }
        }
      }

      require('telescope').setup({
        defaults = {
            mappings = {
                i = {
                  ["<M-t>"] = require('telescope.actions').close,
                  ["<M-w>"] = require('telescope.actions').close,
                  ["<M-q>"] = require('telescope.actions').close,
                  ["<C-f>"] = require('telescope.actions').close,
                  ["<A-o>"] = require('telescope.actions').close,
                  ["<M-O>"] = require('telescope.actions').close,
                },
            },
        },
      })

      pcall(telescope.load_extension, 'fzf')
      telescope.load_extension("ui-select")
      telescope.load_extension("noice")

      -- Telescope live_grep in git root
      -- Function to find the git root directory based on the current buffer's path
      local function find_git_root()
        -- Use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        -- If the buffer is not associated with a file, return nil
        if current_file == '' then
          current_dir = cwd
        else
          -- Extract the directory from the current file's path
          current_dir = vim.fn.fnamemodify(current_file, ':h')
        end

        -- Find the Git root directory from the current file's path
        local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 then
          print 'Not a git repository. Searching on current working directory'
          return cwd
        end
        return git_root
      end

      -- Custom live_grep function to search in git root
      local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
          require('telescope.builtin').live_grep {
            search_dirs = { git_root },
          }
        end
      end

      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

      local function telescope_live_grep_open_files()
        require('telescope.builtin').live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end

      local function find_in_home_dir()
        require('telescope.builtin').find_files({ cwd = '~/', hidden = true })
      end

      -- telescope keymaps
      vim.keymap.set('n', '<leader>t', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles', silent=true })

      vim.keymap.set('n', '<C-f>', require('telescope.builtin').current_buffer_fuzzy_find, { desc = 'Fuzzily search in current buffer', silent=true })
      vim.keymap.set('n', '<C-S-F>', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root', silent=true })

      vim.keymap.set('n', '<A-t>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles', silent=true })
      vim.keymap.set('n', '<M-O>', ':Telescope neovim-project discover layout_strategy=vertical<cr>', { desc = '[S]earch [p]rojects [a]ll', silent=true })
      vim.keymap.set('n', '<A-o>', ':Telescope neovim-project history layout_strategy=vertical<cr>', { desc = '[S]earch [p]rojects [r]ecent', silent=true })

      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files', silent=true})
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers', silent=true })
      vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer', silent=true })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message', silent = true })
      vim.keymap.set('n', '<leader>q', require('telescope.builtin').diagnostics, { desc = 'Open diagnostics list', silent = true })

      vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files', silent=true })
      vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope', silent=true })
      vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles', silent=true })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp', silent=true })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord', silent=true })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep', silent=true })
      vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root', silent=true })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics', silent=true })
      vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume', silent=true })
      vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles, { desc = '[S]earch recently [o]pened files', silent=true})
      vim.keymap.set('n', '<leader>su', find_in_home_dir, { desc = '[S]earch user\'s entire [h]ome directory', silent=true })
      vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [k]eymaps', silent=true })
      vim.keymap.set('n', '<leader>spp', ':Telescope neovim-project discover layout_strategy=vertical<cr>', { desc = '[S]earch [p]rojects', silent=true })
      vim.keymap.set('n', '<leader>spr', ':Telescope neovim-project history layout_strategy=vertical<cr>', { desc = '[S]earch [p]rojects [r]ecent', silent=true })
    end
  }
}
