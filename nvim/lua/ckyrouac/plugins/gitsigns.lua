-- Adds git related signs to the gutter, as well as utilities for managing changes

return {
  {
    cond = true,
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "┃" },
        topdelete = { text = "┃" },
        changedelete = { text = "┃" },
        untracked = { text = "┃" },
      },
      preview_config = {
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
        border = 'single',
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.silent = true
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ "n", "v" }, "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to next hunk" })

        map({ "n", "v" }, "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Jump to previous hunk" })

        local function toggle_base()
          local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/||'")
          local default_branch = handle:read("*a"):gsub("%s+", "")
          handle:close()

          gs.change_base(default_branch, true)
        end

        -- Actions
        -- visual mode
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage git hunk" })
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "reset git hunk" })
        -- normal mode
        map("n", "<leader>gs", gs.stage_hunk, { desc = "git stage hunk" })
        map("n", "<leader>gr", gs.reset_hunk, { desc = "git reset hunk" })
        map("n", "<leader>gS", gs.stage_buffer, { desc = "git Stage buffer" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
        map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })
        map("n", "<leader>gp", gs.preview_hunk, { desc = "preview git hunk" })

        -- Toggles
        map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "toggle blame" })
        map("n", "<leader>gtd", gs.toggle_deleted, { desc = "toggle deleted" })
        map("n", "<leader>gbm", toggle_base, { desc = "set gitsigns base to main/master" })
        map("n", "<leader>gbr", function()
          gs.reset_base(true)
        end, { desc = "reset gitsigns base" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
      end,
    },
  },
}
