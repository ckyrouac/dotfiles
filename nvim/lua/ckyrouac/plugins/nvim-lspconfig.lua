return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    cond = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
    config = function()
      vim.lsp.inlay_hint.enable(false)

      -- :LspInfo border
      require("lspconfig.ui.windows").default_options = {
        border = "rounded",
      }

      -- neovim lua configuration
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })

      local servers = {
        yamlls = {},
        clangd = {},
        gopls = {
          gopls = {
            semanticTokens = true,
          },
        },
        pyright = {},
        -- rust_analyzer = {},
        -- tsserver = {},
        -- html = { filetypes = { 'html', 'twig', 'hbs'} },

        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              disable = { "missing-fields" },
              globals = { "vim" },
            },
          },
        },
      }

      -- -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local lspconfig = require("lspconfig")
      for server, config in pairs(servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      -- Set up LSP keymaps via LspAttach autocmd so they apply to any buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          local nmap = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true, noremap = true })
          end

          nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
          nmap("<leader>ca", require("actions-preview").code_actions, "Action")

          nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
          nmap(
            "<C-MiddleMouse>",
            "<LeftMouse><LeftRelease><cmd>:lua require('telescope.builtin').lsp_references()<CR>",
            "Goto References"
          )

          nmap("gd", vim.lsp.buf.definition, "Goto definition")
          nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
          nmap("gt", vim.lsp.buf.type_definition, "Goto Type definition")

          nmap(
            "<C-LeftMouse>",
            "<LeftMouse><LeftRelease><cmd>:lua require('telescope.builtin').lsp_definitions()<CR>",
            "Goto Definition"
          )

          nmap("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
          nmap(
            "<C-RightMouse>",
            "<LeftMouse><LeftRelease><cmd>:lua require('telescope.builtin').lsp_implementations()<CR>",
            "Goto References"
          )

          nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")

          nmap("K", vim.lsp.buf.hover, "Hover Documentation")

          nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
          nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")

          -- gopls semantic tokens fix
          if client and client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
              range = true,
            }
          end
        end,
      })

      -- on_attach is empty since keymaps are handled by LspAttach autocmd above
      local on_attach = function(client, bufnr)
      end

      -- Ensure the servers above are installed
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      mason_lspconfig.setup_handlers({
        -- Default handler for all servers
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
            semanticTokens = true,
          })
        end,
        -- Disable rust_analyzer since rustaceanvim handles it
        ["rust_analyzer"] = function() end,
      })

      -- configure the built in diagnostics
      vim.diagnostic.config({
        signs = true,
        update_in_insert = false,
        severity_sort = true,
        underline = {
          severity = { max = vim.diagnostic.severity.INFO },
        },
        virtual_text = false,

        -- virtual_text = {
        --   severity = {
        --     min = vim.diagnostic.severity.ERROR,
        --   }
        -- }
      })

      -- c config
      -- require("cmp_nvim_lsp")

      require("lspconfig").clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
        },
      })

      require("lspconfig").nushell.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require("lspconfig").yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
          },
        },
      })

      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        pattern = { "*" },
        callback = function()
          if vim.bo.filetype == "nu" then
            return
          end

          -- Only highlight if an LSP client with documentHighlight support is attached
          for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client.server_capabilities.documentHighlightProvider then
              vim.lsp.buf.document_highlight()
              return
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
        pattern = { "*" },
        callback = function()
          if vim.bo.filetype == "nu" then
            return
          end

          -- Only highlight if an LSP client with documentHighlight support is attached
          for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client.server_capabilities.documentHighlightProvider then
              vim.lsp.buf.document_highlight()
              return
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        pattern = { "*" },
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end,
  },
}
