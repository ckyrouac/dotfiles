return {
  {
    "coffebar/neovim-project",

    -- Disable neovim-project because it breaks the rustacean LSP
    -- from loading upon startup unless a rust buffer is active
    cond = false,
    opts = {
      projects = { -- define project roots
        "~/projects/*",
        "~/dotfiles",
        "~/.local/share/nvim/lazy/*",
      },
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
      local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

      vim.api.nvim_create_autocmd("User", {
        pattern = { "SessionLoadPost" },
        group = augroup,
        desc = "Update git env for dotfiles after loading session",
        callback = function()
          require("nvim-dap-projects").search_project_config()
        end,
      })
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "ckyrouac/telescope.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
  },
}
