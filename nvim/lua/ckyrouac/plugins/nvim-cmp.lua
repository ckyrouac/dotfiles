return {
  {
    -- Autocompletion
    "ckyrouac/nvim-cmp",
    cond = true,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",

      "onsails/lspkind.nvim",
    },
    config = function()
      -- [[ Configure nvim-cmp ]]
      -- See `:help cmp`
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      local lspkind = require("lspkind")

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = {
            selection_order = 'near_cursor',
            vertical_positioning = "above",
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {},
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_next_item(),
          ["<C-n>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            -- select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          -- { name = "copilot", max_item_count = 5 },
          { name = "nvim_lsp", max_item_count = 15 },
          { name = "luasnip", max_item_count = 5 },
          { name = "path", max_item_count = 5 },
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = {
              nvim_lsp = " LSP",
              luasnip = " LuaSnip",
              path = " Path",
              -- copilot = " Copilot",
            },
            max_width = 50,
            -- symbol_map = { Copilot = "" },
            ellipsis_char = "...",
            show_labelDetails = true,
          }),
        },
      })
    end,
  },
}
