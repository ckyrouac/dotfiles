return {
  {
    "otavioschwanck/arrow.nvim",
    cond = true,
    config = function()
      require("arrow").setup({
        show_icons = true,
        leader_key = "<leader>b",
        buffer_leader_key = "m", -- Per Buffer Mappings
        per_buffer_config = {
          lines = 4, -- Number of lines showed on preview.
          sort_automatically = true, -- Auto sort buffer marks.
          satellite = { -- defualt to nil, display arrow index in scrollbar at every update
            enable = true,
            overlap = true,
            priority = 1000,
          },
          zindex = 1, --default 50
          treesitter_context = nil, -- it can be { line_shift_down = 2 }, currently not usable, for detail see https://github.com/otavioschwanck/arrow.nvim/pull/43#issue-2236320268
        },
        index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
      })
    end,
  },
}
