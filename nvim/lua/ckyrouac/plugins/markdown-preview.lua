return {
  {
    "iamcco/markdown-preview.nvim",
    cond = true,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function ()
      vim.g.mkdp_auto_close = 0
      vim.keymap.set("n", "<leader>op", ":MarkdownPreview<cr>", { silent = true, desc = "Markdown Preview" })
    end
  },
}
