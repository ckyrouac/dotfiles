return {
  {
    "mfussenegger/nvim-lint",
    cond = true,
    dependencies = {},
    config = function()
      local custom_golang = require("lint").linters.golangcilint
      custom_golang.append_fname = false
      custom_golang.args = {
          "run",
          "--out-format",
          "json",
          "--build-tags",
          "exclude_graphdriver_btrfs,btrfs_noversion,exclude_graphdriver_devicemapper,containers_image_openpgp,remote",
      }

      require("lint").linters_by_ft = {
        go = { "golangcilint" },
        bash = { "spellcheck" },
        yaml = { "yamllint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
