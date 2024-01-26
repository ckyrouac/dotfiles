-- See `:help telescope` and `:help telescope.setup()`

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "🔎 ",
          selection_caret = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            vertical = {
              height = 0.9,
              width = 0.5,
              prompt_position = "top",
              previewer = true,
              mirror = true,
              preview_height = 0.5,
              preview_cutoff = 25,
            },
            horizontal = {
              prompt_position = "top",
            },
          },
        },
        pickers = {
          ["neovim-project"] = {
            layout_strategy = "vertical",
          },
          lsp_definitions = {
            theme = "cursor",
            previewer = false,
          },
          lsp_references = {
            layout_strategy = "vertical",
            show_line = false,
          },
          lsp_implementations = {
            theme = "cursor",
            previewer = false,
          },
          current_buffer_fuzzy_find = {
            layout_strategy = "vertical",
          },
          find_files = {
            layout_strategy = "vertical",
          },
          live_grep = {
            layout_strategy = "vertical",
          },
          oldfiles = {
            layout_strategy = "vertical",
          },
          git_files = {
            layout_strategy = "vertical",
          },
          buffers = {
            layout_strategy = "vertical",
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
          },
        },
      })

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<M-w>"] = require("telescope.actions").close,
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("noice")
      telescope.load_extension("advanced_git_search")

      local function telescope_live_grep_open_files()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end

      local function find_in_home_dir()
        require("telescope.builtin").find_files({ cwd = "~/", hidden = true })
      end

      local function find_in_cwd()
        require("telescope.builtin").find_files({
          cwd = vim.fn.getcwd(),
          hidden = true,
          name = "asdf",
          follow = true,
          prompt_title = "Find Files in Project",
        })
      end

      -- telescope keymaps

      -- top level
      vim.keymap.set(
        "n",
        "<leader>?",
        require("telescope.builtin").live_grep,
        { desc = "Search entire project", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>/",
        require("telescope.builtin").live_grep,
        { desc = "Search entire project", silent = true }
      )
      vim.keymap.set("n", "<leader><space>", find_in_cwd, { desc = "Find files in project", silent = true })

      vim.keymap.set(
        "n",
        "<leader>e",
        vim.diagnostic.open_float,
        { desc = "Open floating diagnostic message", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>q",
        require("telescope.builtin").diagnostics,
        { desc = "Open diagnostics list", silent = true }
      )
      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", { desc = "Undo history", silent = true })
      vim.keymap.set(
        "n",
        "<leader>st",
        require("telescope.builtin").builtin,
        { desc = "Telescope builtin", silent = true }
      )
      vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Help", silent = true })
      vim.keymap.set(
        "n",
        "<leader>sw",
        require("telescope.builtin").grep_string,
        { desc = "Current Word", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>sd",
        require("telescope.builtin").diagnostics,
        { desc = "Diagnostics", silent = true }
      )
      vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "Resume", silent = true })
      vim.keymap.set(
        "n",
        "<leader>sk",
        require("telescope.builtin").keymaps,
        { desc = "Search keymaps", silent = true }
      )

      -- projects
      vim.keymap.set(
        "n",
        "<leader>spa",
        ":Telescope neovim-project discover layout_strategy=vertical<cr>",
        { desc = "Search projects all", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>spr",
        ":Telescope neovim-project history layout_strategy=vertical<cr>",
        { desc = "Search projects recent", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>sx",
        ":noh<CR>",
        { desc = "Clear search highlights", silent = true })

      -- files
      vim.keymap.set(
        "n",
        "<leader>sfr",
        require("telescope.builtin").oldfiles,
        { desc = "Recently Opened Files", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>sfo",
        require("telescope.builtin").buffers,
        { desc = "Currently Open Files", silent = true }
      )
      vim.keymap.set("n", "<leader>sfu", find_in_home_dir, { desc = "Entire home directory", silent = true })

      -- grep contents
      vim.keymap.set(
        "n",
        "<leader>sco",
        telescope_live_grep_open_files,
        { desc = "Currently Open Files", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>scp",
        require("telescope.builtin").live_grep,
        { desc = "Entire Project", silent = true }
      )
    end,
  },
}
