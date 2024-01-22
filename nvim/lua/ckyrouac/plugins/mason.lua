return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      -- mason-lspconfig requires that these setup functions are called in this order
      -- before setting up the servers.
      require("mason").setup({
        ensure_installed = {
          "clangd",
          "codelldb",
          "delve",
          "gopls",
          "lua-language-server",
          "luacheck",
          "stylua",
          "rust-analyzer",
        },
        automatic_installation = true,
      })
      require("mason-lspconfig").setup()

      -- Debuggers
      require("mason-nvim-dap").setup({
        ensure_installed = { "delve", "codelldb" },
        automatic_installation = true,
      })
    end,
  },
}
