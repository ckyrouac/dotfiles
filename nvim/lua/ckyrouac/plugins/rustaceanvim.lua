return {
  {
    "mrcjkb/rustaceanvim",
    -- Use local development version with CLI diagnostics fallback
    dir = "~/projects/rustaceanvim",
    cond = true,
    lazy = false,
    ft = { "rust" },
    config = function()
    end,
  },
}
