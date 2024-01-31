return {
  {
    cond = false,
    'ckyrouac/hoverhints.nvim',
    config = function ()
      require("hoverhints").setup({
        scrollbar_offset = 0
      })
    end
  }
}
