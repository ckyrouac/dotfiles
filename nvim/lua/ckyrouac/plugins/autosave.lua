return {
  {
    "pocco81/auto-save.nvim",
    cond = true,
    config = function ()
      require('auto-save').setup({
        execution_message = {
          message = function() -- message to print on save
            return ("")
          end,
        }
      })
    end
  }
}
