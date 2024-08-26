return {
  "folke/which-key.nvim",
  opts = {},
  cond = true,
  config = function()
    require("which-key").setup({
      icons = {
        mappings = false,
        group = "",
      },
      disable = {
        ft = {
          "nofile",
          "toggleterm",
        },
      },
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "z", mode = { "n", "v" } },
        { "g", mode = { "n", "v" } },
        -- { "<auto>", mode = "nixsotc" },
      },
    })

    require("which-key").add({
      { "<leader>c", group = "Code" },
      { "<leader>c_", hidden = true },
      { "<leader>d", group = "Dap" },
      { "<leader>d_", hidden = true },
      { "<leader>db", group = "Breakpoints" },
      { "<leader>db_", hidden = true },
      { "<leader>dh", group = "Hover" },
      { "<leader>dh_", hidden = true },
      { "<leader>dr", group = "REPL" },
      { "<leader>dr_", hidden = true },
      { "<leader>ds", group = "Steps" },
      { "<leader>ds_", hidden = true },
      { "<leader>du", group = "Widgets" },
      { "<leader>du_", hidden = true },
      { "<leader>f", group = "Find" },
      { "<leader>f_", hidden = true },
      { "<leader>g", group = "Git" },
      { "<leader>g_", hidden = true },
      { "<leader>gt", group = "Toggle" },
      { "<leader>gt_", hidden = true },
      { "<leader>h", group = "Help" },
      { "<leader>h_", hidden = true },
      { "<leader>m", group = "Markdown" },
      { "<leader>m_", hidden = true },
      { "<leader>o", group = "Open Tool" },
      { "<leader>o_", hidden = true },
      { "<leader>p", group = "Projects" },
      { "<leader>p_", hidden = true },
      { "<leader>r", group = "Rename" },
      { "<leader>r_", hidden = true },
      { "<leader>s", group = "Search" },
      { "<leader>s_", hidden = true },
      { "<leader>t", group = "Test" },
      { "<leader>t_", hidden = true },
      { "<leader>to", group = "Output" },
      { "<leader>to_", hidden = true },
      { "<leader>w", group = "Workspace" },
      { "<leader>w_", hidden = true },
      { "<leader>x", group = "Trouble" },
      { "<leader>x_", hidden = true },
    })

    require("which-key").add({
      {
        mode = { "v" },
        { "<leader>d", desc = "Dap" },
        { "<leader>dh", desc = "Hover" },
        { "<leader>g", desc = "Git" },
      },
    })
  end,
}
