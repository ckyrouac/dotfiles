return {
  {
    'akinsho/toggleterm.nvim',
    config = function ()
	local Terminal  = require('toggleterm.terminal').Terminal
        require("toggleterm").setup()

	local lazygit = Terminal:new({
	  cmd = "gitui",
	  dir = "git_dir",
	  direction = "float",
	  float_opts = {
	    border = "rounded",
	  },
	  on_open = function(term)
	    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", {silent = true})
	    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<A-q>", "<cmd>close<cr>", {silent = true})
	  end,
	  on_close = function()
	  end,
	})

	function _lazygit_toggle()
	  lazygit:toggle()
	end

	vim.api.nvim_set_keymap("n", "<A-3>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
      end
  }
}
