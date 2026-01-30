return {
  {
    "mrcjkb/rustaceanvim",
    cond = true,
    lazy = false,
    version = "^6",
    ft = { "rust" },
    init = function()
      -- vim.g.rustaceanvim as a function is called lazily when needed
      vim.g.rustaceanvim = function()
        -- blink.cmp should be loaded by now since this is called lazily
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, blink = pcall(require, "blink.cmp")
        if ok then
          capabilities = blink.get_lsp_capabilities(capabilities)
        end

        return {
          server = {
            capabilities = capabilities,
            settings = {
              ["rust-analyzer"] = {
                checkOnSave = {
                  command = "clippy",
                },
                diagnostics = {
                  enable = true,
                },
                cargo = {
                  allFeatures = true,
                },
                procMacro = {
                  enable = true,
                },
              },
            },
          },
          tools = {
            float_win_config = {
              border = "rounded",
            },
          },
        }
      end
    end,
  },
}
