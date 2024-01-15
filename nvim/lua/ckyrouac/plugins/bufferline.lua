return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function ()
            local bufferline_tab_bg_color='#212121'
            require("bufferline").setup({
                options = {
                    close_command = "SmartQ %d",
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            highlight = "Directory",
                            separator = true
                        },
                        {
                            filetype = "SidebarNvim",
                            text = "Sidebar",
                            highlight = "Directory",
                            separator = true
                        }
                    },
                },
                highlights = {
                    tab = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- tab_selected = {
                    --     fg = '<colour-value-here>',
                    --     bg = '<colour-value-here>',
                    -- },
                    close_button_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- close_button_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    buffer_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- buffer_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    numbers = {
                        bg = bufferline_tab_bg_color,
                    },
                    numbers_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- numbers_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    diagnostic = {
                        bg = bufferline_tab_bg_color,
                    },
                    diagnostic_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- diagnostic_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    hint = {
                        bg = bufferline_tab_bg_color,
                    },
                    hint_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- hint_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    hint_diagnostic = {
                        bg = bufferline_tab_bg_color,
                    },
                    hint_diagnostic_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- hint_diagnostic_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    info = {
                        bg = bufferline_tab_bg_color,
                    },
                    info_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- info_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    info_diagnostic = {
                        bg = bufferline_tab_bg_color,
                    },
                    info_diagnostic_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- info_diagnostic_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    warning = {
                        bg = bufferline_tab_bg_color,
                    },
                    warning_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- warning_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    warning_diagnostic = {
                        bg = bufferline_tab_bg_color,
                    },
                    warning_diagnostic_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- warning_diagnostic_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    error = {
                        bg = bufferline_tab_bg_color,
                    },
                    error_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- error_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    error_diagnostic = {
                        bg = bufferline_tab_bg_color,
                    },
                    error_diagnostic_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- error_diagnostic_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    modified_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- modified_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    -- duplicate_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    duplicate_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    duplicate = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- separator_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    separator_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    separator = {
                        bg = bufferline_tab_bg_color,
                    },
                    indicator_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- indicator_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    -- pick_selected = {
                    --     bg = bufferline_tab_bg_color,
                    -- },
                    pick_visible = {
                        bg = bufferline_tab_bg_color,
                    },
                    pick = {
                        bg = bufferline_tab_bg_color,
                    },
                    offset_separator = {
                        bg = bufferline_tab_bg_color,
                    },
                    trunc_marker = {
                        bg = bufferline_tab_bg_color,
                    },
                    fill = {
                        bg = '#292929',
                    },
                    background = {
                        bg = bufferline_tab_bg_color,
                    },
                    close_button = {
                        bg = bufferline_tab_bg_color,
                    },
                    tab_close = {
                        bg = bufferline_tab_bg_color,
                    },
                    tab_separator = {
                        bg = bufferline_tab_bg_color,
                    },
                    -- tab_separator_selected = {
                    --   bg = bufferline_tab_bg_color,
                    -- },
                    modified = {
                        bg = bufferline_tab_bg_color,
                    }
                }
            })
        end
    }
}
