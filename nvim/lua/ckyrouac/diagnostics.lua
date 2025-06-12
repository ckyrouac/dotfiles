vim.diagnostic.config({
  float = { border = "rounded" },
})

local signs = { Error = "󰅚", Warn = "󰀪", Hint = "💡", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

return {
  Signs = signs
}
