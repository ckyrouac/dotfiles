return {
  {
    "fnune/recall.nvim",
    version = "*",
    config = function()
      local recall = require("recall")

      recall.setup({
        telescope = {
          autoload = false,
        },
      })

      vim.keymap.set("n", "mm", recall.toggle, { noremap = true, silent = true, desc = "Toggle mark" })
      vim.keymap.set("n", "mn", recall.goto_next, { noremap = true, silent = true, desc = "Go to next mark"})
      vim.keymap.set("n", "mp", recall.goto_prev, { noremap = true, silent = true, desc = "Go to previous mark" })
      vim.keymap.set("n", "mc", recall.clear, { noremap = true, silent = true, desc = "Clear marks" })
      vim.keymap.set("n", "ms", ":Telescope recall<CR>", { noremap = true, silent = true, desc = "Search marks"})
    end
  }
}
