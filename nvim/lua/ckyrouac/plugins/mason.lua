return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    cond = true,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- mason-lspconfig requires that these setup functions are called in this order
      -- before setting up the servers.
      require("mason").setup({
        ui = {
          border = 'rounded'
        },
        ensure_installed = {
          "bash-language-server",
          "clangd",
          "codelldb",
          "delve",
          "gopls",
          "lua-language-server",
          "luacheck",
          "pyright",
          "stylua",
          "jq",
          "jsonlint",
          "goimports",
          "xmlformatter",
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
