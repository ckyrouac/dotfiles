return {
  {
    'nvim-lua/plenary.nvim',
    config = function ()
      local List=require('plenary.collections.py_list');
      local DisableLineNumberWindowList = List {"NvimTree", "SidebarNvim", "GitSigns*", "HoverHint"};

      -- relative line numbers
      vim.api.nvim_create_autocmd({"BufEnter","FocusGained","InsertLeave","WinEnter"}, {
        pattern = {"*"},
        callback = function()
          if DisableLineNumberWindowList:contains(vim.bo.filetype) then
            vim.o.rnu = false
            vim.o.number = false
          else
            vim.o.rnu = true
          end
        end
      })

      vim.api.nvim_create_autocmd({"BufLeave","FocusLost","InsertEnter","WinLeave"}, {
        pattern = {"*"},
        callback = function()
          if DisableLineNumberWindowList:contains(vim.bo.filetype) then
            vim.o.rnu = false
            vim.o.number = false
          else
            vim.o.rnu = false
            vim.o.number = true
          end
        end
      })
    end
  }
}
