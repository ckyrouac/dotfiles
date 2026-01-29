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

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
    config = function()
      -- :LspInfo border
      require("lspconfig.ui.windows").default_options = {
        border = "rounded",
      }

      -- neovim lua configuration
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })

      local servers = {
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

      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        -- populate workspace diagnostics
        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)

        -- A function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
        end

        nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
        nmap("<leader>ca", require("actions-preview").code_actions, "Action")

        nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
        nmap(
          "<C-MiddleMouse>",
          "<LeftMouse><LeftRelease><cmd>:lua require('telescope.builtin').lsp_references()<CR>",
          "Goto References"
        )

        -- nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        -- vim.keymap.set("n", "gd", function () vim.lsp.buf.definition() end, { buffer = bufnr, desc = "goto definition" })
        nmap("gd", function () vim.lsp.buf.definition() end, "Goto Definition")

        nmap(
          "<C-LeftMouse>",
          "<LeftMouse><LeftRelease><cmd>:lua require('telescope.builtin').lsp_definitions()<CR>",
          "Goto Definition"
        )

        nmap("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        nmap(
          "<C-RightMouse>",
          "<LeftMouse><LeftRelease><cmd>:lua require('telescope.builtin').lsp_implementations()<CR>",
          "Goto References"
        )

        nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
        -- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")

        -- require('telescope.builtin').lsp_code_action
        -- nmap("<M-CR>", vim.lsp.buf.code_action, "Code Action")

        -- See `:help K` for why this keymap
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")

        -- Create a command `:Format` local to the LSP buffer
        -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        --   vim.lsp.buf.format()
        -- end, { desc = 'Format current buffer with LSP' })
        if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
            range = true,
          }
        end
      end

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })



      mason_lspconfig.setup_handlers {
        ['rust_analyzer'] = function() end,
      }

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
            semanticTokens = true,
          })
        end,
      })

      vim.g.rustaceanvim = {
        server = {
          on_attach = on_attach,
        },
        tools = {
          float_win_config = {
            border = "rounded",
          },
        },
      }

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
      require("cmp_nvim_lsp")

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

      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        pattern = { "*" },
        callback = function()
          if vim.bo.filetype == "nu" then
            return
          end

          vim.lsp.buf.document_highlight()
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
        pattern = { "*" },
        callback = function()
          if vim.bo.filetype == "nu" then
            return
          end

          vim.lsp.buf.document_highlight()
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
