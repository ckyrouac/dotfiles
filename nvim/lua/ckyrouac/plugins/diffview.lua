-- Global variable to store the current diffview base
_G.diffview_base = nil

return {
  {
    "sindrets/diffview.nvim",
    cond = true,
    config = function ()
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
