local function flatten_dap_configurations()
  local configurations = require("dap").configurations
  local flat_configs = {}

  for type, configs in pairs(configurations) do
    for _, conf in ipairs(configs) do
      conf.file_type = type
      table.insert(flat_configs, conf)
    end
  end

  return flat_configs
end

local function select_config_and_run(opts)
  local configurations = flatten_dap_configurations()
  opts = opts or {}
  require("dap.ui").pick_one(configurations, "Configuration: ", function(i)
    return i.file_type .. ": " .. i.name
  end, function(configuration)
    if configuration then
      require("dap").run(configuration, opts)
    else
      vim.notify("No configuration selected", vim.log.levels.INFO)
    end
  end)
end
vim.keymap.set("n", "<F10>", select_config_and_run, { silent = true, desc = "DAP Select Config" })

-- function keys
vim.keymap.set("n", "<F4>", ":lua require('dapui').toggle()<CR>", { silent = true, desc = "Toggle DAP UI" })
vim.keymap.set("n", "<S-F4>", ":lua require('dapui').open({reset=true})<CR>", { silent = true, desc = "Reset DAP UI" })
vim.keymap.set(
  "n",
  "<F5>",
  ":lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>",
  { silent = true, desc = "Toggle Breakpoint" }
)
vim.keymap.set("n", "<F9>", ":lua require('dap').continue()<CR>", { silent = true, desc = "DAP Continue" })

vim.keymap.set("n", "<F8>", ":lua require('dap').step_over()<CR>", { silent = true, desc = "Step Over" })
vim.keymap.set("n", "<F7>", ":lua require('dap').step_into()<CR>", { silent = true, desc = "Step Into" })
vim.keymap.set("n", "<F6>", ":lua require('dap').step_out()<CR>", { silent = true, desc = "Step Out" })

-- center search results
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set(
  'c', '<CR>',
  function() return vim.fn.getcmdtype() == '/' and '<CR>zz' or '<CR>' end,
  { expr = true }
)

return {}
