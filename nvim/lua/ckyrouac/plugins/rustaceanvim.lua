return {
  {
    "mrcjkb/rustaceanvim",
    cond = true,
    lazy = false,
    version = "^6",
    ft = { "rust" },
    init = function()
      -- Must be set before plugin loads
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
