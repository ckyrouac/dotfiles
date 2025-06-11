-- This table will store the original highlights before we dim them
local original_highlights = {}
-- This state variable prevents redundant commands from causing flicker
local is_dimmed = false

-- Define your desired inactive background color
local inactive_bg = "#101010" -- A dark, cool gray

-- Create an autocommand group for organization
local augroup = vim.api.nvim_create_augroup("DimInactiveNvim", { clear = true })

-- Function to capture the original highlights if we haven't already
local function capture_original_highlights()
  if next(original_highlights) == nil then
    -- Get the full highlight definition, not just the background color
    original_highlights.Normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    original_highlights.LineNr = vim.api.nvim_get_hl(0, { name = "LineNr" })
    original_highlights.SignColumn = vim.api.nvim_get_hl(0, { name = "SignColumn" })
    original_highlights.FoldColumn = vim.api.nvim_get_hl(0, { name = "FoldColumn" })
    -- Add any other highlight groups you want to manage here
  end
end

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "WinLeave" }, {
  group = augroup,
  pattern = "*",
  desc = "Dim background of inactive nvim windows",
  callback = function(args)
    if is_dimmed then return end -- Don't run if already dimmed

    capture_original_highlights() -- Ensure we have the original values saved

    -- Directly set the background for each group
    vim.api.nvim_set_hl(0, "Normal", { bg = inactive_bg })
    vim.api.nvim_set_hl(0, "LineNr", { bg = inactive_bg })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = inactive_bg })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = inactive_bg })

    -- if vim.api.nvim_win_is_valid(args.win) then
    --   vim.api.nvim_win_set_option(args.win, "winhighlight", "Normal:{bg=red}")
    -- end

    is_dimmed = true
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "WinEnter" }, {
  group = augroup,
  pattern = "*",
  desc = "Restore background of active nvim windows",
  callback = function(args)
    -- Only restore if it was previously dimmed
    if not is_dimmed then return end

    -- Restore the entire original highlight definition, not just the background
    vim.api.nvim_set_hl(0, "Normal", original_highlights.Normal)
    vim.api.nvim_set_hl(0, "LineNr", original_highlights.LineNr)
    vim.api.nvim_set_hl(0, "SignColumn", original_highlights.SignColumn)
    vim.api.nvim_set_hl(0, "FoldColumn", original_highlights.FoldColumn)

    -- if vim.api.nvim_win_is_valid(args.win) then
    --   vim.api.nvim_win_set_option(args.win, "winhighlight", "Normal:{bg=blue}")
    -- end

    is_dimmed = false
  end,
})

-- It's also good practice to handle colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  pattern = "*",
  desc = "Clear cached highlights on colorscheme change",
  callback = function()
    -- Clear out the old cached values
    original_highlights = {}
    -- Unset the dimmed state so it can be re-applied correctly
    is_dimmed = false
  end,
})


-- vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
--   pattern = { "*" },
--   callback = function()
--     vim.api.nvim_set_hl(0, "Normal", original_highlights.Normal)
--     vim.api.nvim_set_hl(0, "LineNr", original_highlights.LineNr)
--     vim.api.nvim_set_hl(0, "SignColumn", original_highlights.SignColumn)
--     vim.api.nvim_set_hl(0, "FoldColumn", original_highlights.FoldColumn)
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
--   pattern = { "*" },
--   callback = function()
--     vim.api.nvim_set_hl(0, "Normal", { bg = inactive_bg })
--     vim.api.nvim_set_hl(0, "LineNr", { bg = inactive_bg })
--     vim.api.nvim_set_hl(0, "SignColumn", { bg = inactive_bg })
--     vim.api.nvim_set_hl(0, "FoldColumn", { bg = inactive_bg })
--   end,
-- })
--
