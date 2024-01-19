return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function ()
            require("bufferline").setup({
                options = {
                    close_command = "SmartQ %d",
                    offsets = {
                        {
                            padding = 1,
                            filetype = "NvimTree",
                            text = "🗄File Explorer",
                            text_align = "left",
                            highlight = "Normal",
                            separator = false,
                        },
                        {
                            padding = 1,
                            filetype = "SidebarNvim",
                            text = "💁 Sidebar",
                            text_align = "left",
                            highlight = "Normal",
                            separator = false,
                        }
                    },
                },
                highlights = {
                    background = {
                        bg = '#1e1f22',
                    },
                }
            })
        end
    }
}
