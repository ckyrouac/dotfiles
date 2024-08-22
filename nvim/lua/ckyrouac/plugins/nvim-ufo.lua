return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async'
    },
    cond = true,
    init = function()
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        vim.o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]
        vim.o.foldcolumn = 'auto:9'
    end,
    config = function()
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.textDocument.foldingRange = {
          -- dynamicRegistration = false,
          -- lineFoldingOnly = true
      -- }


      -- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      -- for _, ls in ipairs(language_servers) do
          -- require('lspconfig')[ls].setup({
              -- capabilities = capabilities
              -- -- you can add other fields for setting up lsp server in this table
          -- })
      -- end


      -- -- Option 3: treesitter as a main provider instead
      -- -- (Note: the `nvim-treesitter` plugin is *not* needed.)
      -- -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
      -- -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
      require('ufo').setup({
          provider_selector = function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
          end
      })
      require('ufo').setup()
    end,
  }
}
