return {
  {
    "luukvbaal/statuscol.nvim", config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        -- configuration goes here, for example:
        relculright = true,
        segments = {
          {
            sign = { namespace = { "gitsigns" }, name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false },
            click = "v:lua.ScSa",
          },
          { text = { builtin.foldfunc }, click = "v:lua.ScFa", colwidth = 2},
          {
            sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, colwidth = 2, auto = true, foldclosed = true},
            click = "v:lua.ScSa"
          },
          {
            sign = { namespace = { "marks" }, name = { ".*" }, maxwidth = 1, colwidth = 2, auto = true },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa", },
          {
            sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
            click = "v:lua.ScSa"
          },
        }
      })
    end,
  }
}
