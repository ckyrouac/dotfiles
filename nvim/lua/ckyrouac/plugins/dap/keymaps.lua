-- function keys
vim.keymap.set("n", "<F4>", ":lua require('dapui').toggle()<CR>", { silent = true, desc = 'Toggle DAP UI' })
vim.keymap.set("n", "<F5>", ":lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>", { silent = true, desc = 'Toggle Breakpoint' })
vim.keymap.set("n", "<F9>", ":lua require('dap').continue()<CR>", { silent = true, desc = 'DAP Continue' })

vim.keymap.set("n", "<F8>", ":lua require('dap').step_over()<CR>", { silent = true, desc = 'Step Over' })
vim.keymap.set("n", "<F7>", ":lua require('dap').step_into()<CR>", { silent = true, desc = 'Step Into' })
vim.keymap.set("n", "<F6>", ":lua require('dap').step_out()<CR>", { silent = true, desc = 'Step Out' })

-- steps
vim.keymap.set("n", "<Leader>dsc", ":lua require('dap').continue()<CR>", { silent = true, desc = 'Continue' })
vim.keymap.set("n", "<Leader>dsv", ":lua require('dap').step_over()<CR>", { silent = true, desc = 'Step Over' })
vim.keymap.set("n", "<Leader>dsi", ":lua require('dap').step_into()<CR>", { silent = true, desc = 'Step Into' })
vim.keymap.set("n", "<Leader>dso", ":lua require('dap').step_out()<CR>", { silent = true, desc = 'Step Out' })

-- hover
vim.keymap.set("n", "<Leader>dhh", ":lua require('dap.ui.widgets').hover()<CR>", { silent = true, desc = 'Hover' })
vim.keymap.set("v", "<Leader>dhv", ":lua require('dap.ui.variables').visual_hover()<CR>", { silent = true, desc = 'Visual Hover' })

-- widgets
vim.keymap.set("n", "<Leader>duh", ":lua require('dap.ui.widgets').hover()<CR>", { silent = true, desc = 'UI Hover' })
vim.keymap.set(
  "n",
  "<Leader>duf",
  ":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<CR>",
  { silent = true, desc = 'UI Widgets Float' }
)

-- repl
vim.keymap.set("n", "<Leader>dro", ":lua require('dap').repl.open()<CR>", { silent = true, desc = 'Open REPL' })
vim.keymap.set("n", "<Leader>drl", ":lua require('dap').repl.run_last()<CR>", { silent = true, desc = 'REPL run last' })

-- breakpoints
vim.keymap.set(
  "n",
  "<Leader>dbc",
  ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { silent = true, desc = 'Breakpoint Condition' }
)
vim.keymap.set(
  "n",
  "<Leader>dbm",
  ":lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ') })<CR>",
  { silent = true, desc = 'Breakpoint Log Message' }
)
vim.keymap.set("n", "<Leader>dbt", ":lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>", { silent = true, desc = 'Toggle Breakpoint' })

-- scopes
vim.keymap.set(
  "n",
  "<Leader>dc",
  ":lua require('dap.ui.variables').scopes()<CR>",
  { silent = true, desc = "Scopes" }
)

-- toggle UI
vim.keymap.set("n", "<Leader>di", ":lua require('dapui').toggle()<CR>", { silent = true, desc = "Toggle UI" })

return {}
