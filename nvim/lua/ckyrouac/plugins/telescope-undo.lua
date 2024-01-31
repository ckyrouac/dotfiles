return {
  {
    "debugloop/telescope-undo.nvim",
    cond = true,
    dependencies = {
      {
        "ckyrouac/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      -- require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
}
