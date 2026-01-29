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
        { "m", mode = { "n", "v" } },
        -- { "<auto>", mode = "nixsotc" },
      },
    })

    require("which-key").add({
      { "<leader>a", group = "AI" },
      { "<leader>a_", hidden = true },
      { "<leader>c", group = "Code" },
      { "<leader>c_", hidden = true },
      { "<leader>d", group = "Dap" },
      { "<leader>d_", hidden = true },
      { "<leader>f", group = "Find" },
      { "<leader>f_", hidden = true },
      { "<leader>g", group = "Git" },
      { "<leader>g_", hidden = true },
      { "<leader>gt", group = "Toggle" },
      { "<leader>gt_", hidden = true },
      { "<leader>gb", group = "Base" },
      { "<leader>gb_", hidden = true },
      { "<leader>h", group = "Help" },
      { "<leader>h_", hidden = true },
      { "<leader>o", group = "Open Tool" },
      { "<leader>o_", hidden = true },
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
      { "<leader>z", group = "Fold" },
      { "<leader>z_", hidden = true },
    })

    require("which-key").add({
      {
        mode = { "v" },
        { "<leader>g", desc = "Git" },
      },
    })
  end,
}
