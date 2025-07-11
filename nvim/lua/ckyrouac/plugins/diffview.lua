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

        map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "DiffviewOpen" })
        map("n", "<leader>gD", function()
          local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/||'")
          local default_branch = handle:read("*a"):gsub("%s+", "")
          handle:close()
          vim.cmd("DiffviewOpen " .. default_branch)
        end, { desc = "Diffview against default branch" })
    end
  },
}
