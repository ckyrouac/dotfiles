vim.keymap.set(
  "n",
  "<leader>e",
  function() vim.cmd.RustLsp({ 'renderDiagnostic', 'current' }) end,
  { desc = "Open floating diagnostic message", silent = true }
)
