return {
  {
    'ggml-org/llama.vim',
    cond = false,
    lazy = false,
    init = function()
      vim.g.llama_config = {
        auto_fim = true,
        show_info = false,
      }
    end,
  }
}
