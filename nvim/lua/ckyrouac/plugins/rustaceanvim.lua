return {
  {
    "mrcjkb/rustaceanvim",
    cond = true,
    lazy = false,
    version = "^4",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = "rounded",
          },
        },
      }
    end,
  },
}
