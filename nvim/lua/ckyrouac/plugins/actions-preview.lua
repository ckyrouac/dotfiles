return {
  {
    "aznhe21/actions-preview.nvim",
    cond = true,
    config = function ()
      require("actions-preview").setup {
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            height = 0.9,
            width = 0.5,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
            mirror = true,
          },
        },
      }
    end
  }
}
