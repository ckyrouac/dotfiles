-- Global variable to store the current diffview base
_G.diffview_base = nil

return {
  {
    "sindrets/diffview.nvim",
    cond = true,
    config = function ()
        require("diffview").setup({
          enhanced_diff_hl = true,
          hooks = {
            diff_buf_read = function(bufnr, ctx)
              -- Get the buffer name to extract the original file path
              local bufname = vim.api.nvim_buf_get_name(bufnr)

              -- Extract the original file path from diffview buffer name
              -- Format is like: diffview:///path/to/repo/.git/xxx/file.lua
              local original_path = bufname:match("%.git/.-/(.+)$")
              if not original_path then
                -- Try alternate pattern for working tree files
                original_path = bufname:match("/([^/]+)$")
              end

              if original_path then
                -- Detect filetype from the original filename
                local ft = vim.filetype.match({ filename = original_path, buf = bufnr })
                if ft then
                  vim.bo[bufnr].filetype = ft

                  -- Try to attach LSP clients that handle this filetype
                  vim.schedule(function()
                    if not vim.api.nvim_buf_is_valid(bufnr) then return end

                    -- Get all active LSP clients
                    local clients = vim.lsp.get_clients()
                    for _, client in ipairs(clients) do
                      -- Check if this client handles the filetype
                      local dominated_filetypes = client.config.filetypes or {}
                      for _, supported_ft in ipairs(dominated_filetypes) do
                        if supported_ft == ft then
                          -- Attach the client to this buffer
                          if not vim.lsp.buf_is_attached(bufnr, client.id) then
                            vim.lsp.buf_attach_client(bufnr, client.id)
                          end
                          break
                        end
                      end
                    end
                  end)
                end
              end
            end,
          },
        })

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.silent = true
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "<leader>gdd", function()
          _G.diffview_base = nil
          vim.cmd("DiffviewOpen")
        end, { desc = "DiffviewOpen" })

        map("n", "<leader>gdm", function()
          local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/||'")
          local default_branch = handle:read("*a"):gsub("%s+", "")
          handle:close()

          -- Get commit message for the default branch
          local msg_handle = io.popen("git log -1 --format='%s' " .. default_branch .. " 2>/dev/null")
          local commit_msg = msg_handle:read("*a"):gsub("%s+$", "")
          msg_handle:close()

          _G.diffview_base = {
            ref = default_branch,
            message = commit_msg
          }

          vim.cmd("DiffviewOpen " .. default_branch)
        end, { desc = "Diffview against default branch" })

        map("n", "<leader>gdp", function()
          local n = vim.fn.input("Number of commits back: ")
          if n and n ~= "" then
            local num = tonumber(n)
            if num and num > 0 then
              local base_ref = "HEAD~" .. num

              -- Get commit message for HEAD~n
              local msg_handle = io.popen("git log -1 --format='%s' " .. base_ref .. " 2>/dev/null")
              local commit_msg = msg_handle:read("*a"):gsub("%s+$", "")
              msg_handle:close()

              _G.diffview_base = {
                ref = base_ref,
                message = commit_msg
              }

              vim.cmd("DiffviewOpen " .. base_ref)
            else
              vim.notify("Invalid number of commits", vim.log.levels.ERROR)
            end
          end
        end, { desc = "Diffview n commits back" })

        map("n", "<leader>gdc", function()
          _G.diffview_base = nil
          vim.cmd("DiffviewClose")
        end, { desc = "Close Diffview" })

        map("n", "<leader>gh", function()
          vim.cmd("DiffviewFileHistory %")
        end, { desc = "Git history (buffer)" })

        map("n", "<leader>gdo", function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          -- Get commits with refs (tags, branches, etc.)
          local handle = io.popen([[git log --oneline --decorate=short -50 --format="%h %d %s" 2>/dev/null]])
          local log_output = handle:read("*a")
          handle:close()

          local entries = {}

          -- Add "Local changes" as first entry
          table.insert(entries, {
            display = "(local changes) - uncommitted modifications",
            value = nil,  -- nil means local/uncommitted changes
            ordinal = "local changes uncommitted modifications",
          })

          -- Parse git log output
          for line in log_output:gmatch("[^\n]+") do
            local hash = line:match("^(%S+)")
            local refs = line:match("%s%((.-)%)") or ""
            local message = line:gsub("^%S+%s*", ""):gsub("^%(.-%)%s*", "")

            local display = hash
            if refs ~= "" then
              display = display .. " (" .. refs .. ")"
            end
            display = display .. " " .. message

            table.insert(entries, {
              display = display,
              value = hash,
              ordinal = hash .. " " .. refs .. " " .. message,
            })
          end

          pickers.new({}, {
            prompt_title = "Git Diff Open - Select base commit",
            layout_strategy = "vertical",
            finder = finders.new_table({
              results = entries,
              entry_maker = function(entry)
                return {
                  value = entry.value,
                  display = entry.display,
                  ordinal = entry.ordinal,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, _)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()

                local files = {}
                if selection.value == nil then
                  -- Local changes: get modified and new files
                  local diff_handle = io.popen("git diff --name-only 2>/dev/null")
                  local staged_handle = io.popen("git diff --cached --name-only 2>/dev/null")
                  local untracked_handle = io.popen("git ls-files --others --exclude-standard 2>/dev/null")

                  for file in diff_handle:read("*a"):gmatch("[^\n]+") do
                    files[file] = true
                  end
                  for file in staged_handle:read("*a"):gmatch("[^\n]+") do
                    files[file] = true
                  end
                  for file in untracked_handle:read("*a"):gmatch("[^\n]+") do
                    files[file] = true
                  end

                  diff_handle:close()
                  staged_handle:close()
                  untracked_handle:close()
                else
                  -- Get files changed since selected commit
                  local diff_handle = io.popen("git diff --name-only " .. selection.value .. " 2>/dev/null")
                  for file in diff_handle:read("*a"):gmatch("[^\n]+") do
                    files[file] = true
                  end
                  diff_handle:close()
                end

                -- Convert to list and open files
                local file_list = {}
                for file, _ in pairs(files) do
                  table.insert(file_list, file)
                end

                if #file_list == 0 then
                  vim.notify("No changed files found", vim.log.levels.INFO)
                  return
                end

                -- Sort files for consistent ordering
                table.sort(file_list)

                -- Close all open buffers first
                vim.cmd("%bdelete!")

                -- Open all files
                for i, file in ipairs(file_list) do
                  local full_path = vim.fn.getcwd() .. "/" .. file
                  if vim.fn.filereadable(full_path) == 1 then
                    if i == 1 then
                      vim.cmd("edit " .. vim.fn.fnameescape(full_path))
                    else
                      vim.cmd("badd " .. vim.fn.fnameescape(full_path))
                    end
                  end
                end

                -- Set gitsigns base to match the selected commit
                local gs = package.loaded.gitsigns
                if gs then
                  if selection.value == nil then
                    -- Local changes: reset gitsigns base
                    gs.reset_base(true)
                    _G.gitsigns_base = nil
                  else
                    -- Set gitsigns base to selected commit
                    gs.change_base(selection.value, true)

                    -- Get commit message and refs for display
                    local msg_handle = io.popen("git log -1 --format='%s' " .. selection.value .. " 2>/dev/null")
                    local commit_msg = msg_handle:read("*a"):gsub("%s+$", "")
                    msg_handle:close()

                    local refs_handle = io.popen("git log -1 --format='%D' " .. selection.value .. " 2>/dev/null")
                    local refs = refs_handle:read("*a"):gsub("%s+$", "")
                    refs_handle:close()

                    _G.gitsigns_base = {
                      ref = selection.value,
                      message = commit_msg,
                      refs = refs
                    }
                  end
                end

                vim.notify("Opened " .. #file_list .. " files", vim.log.levels.INFO)
              end)
              return true
            end,
          }):find()
        end, { desc = "Git diff open - open files changed since commit" })

        -- Clear diffview base when diffview is closed
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "DiffviewFiles",
          callback = function()
            vim.api.nvim_create_autocmd("BufWinLeave", {
              buffer = vim.api.nvim_get_current_buf(),
              callback = function()
                -- Small delay to ensure diffview is fully closed
                vim.defer_fn(function()
                  -- Check if any diffview buffers are still open
                  local diffview_open = false
                  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_valid(buf) then
                      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
                      if ft == 'DiffviewFiles' or ft == 'DiffviewFileHistory' then
                        diffview_open = true
                        break
                      end
                    end
                  end
                  if not diffview_open then
                    _G.diffview_base = nil
                  end
                end, 100)
              end,
            })
          end,
        })
    end
  },
}
