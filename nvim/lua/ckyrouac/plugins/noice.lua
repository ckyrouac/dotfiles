return {
  {
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {},
      dependencies = {
	"MunifTanjim/nui.nvim",
	"rcarriga/nvim-notify",
      },
      config = function ()
        require("noice").setup({
	  messages = {
	    enabled = true,
	    view = false,
	    view_error = "notify",
	    view_warn = "notify",
	    view_history = "messages",
	    view_search = false,
	  },
	  lsp = {
	    hover = {
	      enabled = true
	    },
	    progress = {
	      enabled = false,
	    },
	    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
	    override = {
	      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	      ["vim.lsp.util.stylize_markdown"] = true,
	      ["cmp.entry.get_documentation"] = true,
	    },
	  },
	  presets = {
	    bottom_search = true,
	    command_palette = false,
	    long_message_to_split = true,
	    inc_rename = true,
	    lsp_doc_border = false,
	  },
	})
      end
    }
  }
}
