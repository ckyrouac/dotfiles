return {
  {
    "ldelossa/nvim-dap-projects",
    cond = true,
    event = "VeryLazy",
    config = function()
      require('nvim-dap-projects').search_project_config()
      -- vim.keymap.set("n" "<leader>dp", require('nvim-dap-projects').search_project_config, { silent = true, desc = "Reload project config" })
    end,
  },
}
