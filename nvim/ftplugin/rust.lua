vim.keymap.set(
  "n",
  "<leader>e",
  function() vim.cmd.RustLsp({ 'renderDiagnostic', 'current' }) end,
  { desc = "Open floating diagnostic message", silent = true }
)

-- Manual flyCheck trigger for diagnostics
vim.keymap.set(
  "n",
  "<leader>cf",
  function() vim.cmd.RustLsp('flyCheck') end,
  { desc = "Run cargo check", silent = true }
)
