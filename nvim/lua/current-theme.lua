-- Dynamic Theme Switcher for current-theme.lua

local M = {}

-- Available themes (add/remove as needed)
local themes = {
    "rose-pine",
    "gruvbox", 
    "kanagawa",
    "solarized-osaka",
    "tokyonight",
    "catppuccin",
    "onedark",
    "dracula",
    "nord",
    "nightfox"
}

-- Set your default theme here
local current_theme = "catppuccin"

-- Apply the current theme
local function apply_theme(theme_name)
    local success, _ = pcall(vim.cmd, "colorscheme " .. theme_name)
    if success then
        current_theme = theme_name
        print("Switched to theme: " .. theme_name)
    else
        print("Error: Theme '" .. theme_name .. "' not found")
    end
end

-- Get current theme index
local function get_current_index()
    for i, theme in ipairs(themes) do
        if theme == current_theme then
            return i
        end
    end
    return 1
end

-- Cycle to next theme
local function next_theme()
    local current_index = get_current_index()
    local next_index = current_index % #themes + 1
    apply_theme(themes[next_index])
end

-- Cycle to previous theme
local function prev_theme()
    local current_index = get_current_index()
    local prev_index = current_index == 1 and #themes or current_index - 1
    apply_theme(themes[prev_index])
end

-- Show current theme
local function show_current_theme()
    print("Current theme: " .. current_theme)
end

-- List all available themes (simple print)
local function list_themes()
    print("Available themes:")
    for i, theme in ipairs(themes) do
        local marker = theme == current_theme and " (current)" or ""
        print("  " .. i .. ". " .. theme .. marker)
    end
end

-- Interactive theme selector using Telescope
local function telescope_theme_selector()
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"

    pickers.new({}, {
        prompt_title = "Select Theme",
        finder = finders.new_table {
            results = themes,
            entry_maker = function(entry)
                local display = entry
                if entry == current_theme then
                    display = entry .. " (current)"
                end
                return {
                    value = entry,
                    display = display,
                    ordinal = entry,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                apply_theme(selection.value)
            end)
            return true
        end,
    }):find()
end

-- Set theme by name
local function set_theme(theme_name)
    for _, theme in ipairs(themes) do
        if theme == theme_name then
            apply_theme(theme_name)
            return
        end
    end
    print("Theme '" .. theme_name .. "' not available. Use :ListThemes to see available themes.")
end

-- Set theme by number
local function set_theme_by_number(number)
    if number >= 1 and number <= #themes then
        apply_theme(themes[number])
    else
        print("Invalid theme number. Use 1-" .. #themes)
    end
end

-- Random theme
local function random_theme()
    math.randomseed(os.time())
    local random_index = math.random(1, #themes)
    apply_theme(themes[random_index])
end

-- Create user commands
vim.api.nvim_create_user_command("NextTheme", next_theme, { desc = "Switch to next theme" })
vim.api.nvim_create_user_command("PrevTheme", prev_theme, { desc = "Switch to previous theme" })
vim.api.nvim_create_user_command("CurrentTheme", show_current_theme, { desc = "Show current theme" })
vim.api.nvim_create_user_command("ListThemes", list_themes, { desc = "List all available themes" })
vim.api.nvim_create_user_command("SelectTheme", telescope_theme_selector, { desc = "Interactive theme selector" })
vim.api.nvim_create_user_command("RandomTheme", random_theme, { desc = "Switch to random theme" })

vim.api.nvim_create_user_command("SetTheme", function(opts)
    local arg = opts.args
    if tonumber(arg) then
        set_theme_by_number(tonumber(arg))
    else
        set_theme(arg)
    end
end, { 
    nargs = 1, 
    desc = "Set theme by name or number",
    complete = function()
        return themes
    end
})

-- Keymaps (optional - uncomment if you want them)
vim.keymap.set('n', '<leader>cn', next_theme, { desc = 'Next theme' })
vim.keymap.set('n', '<leader>cp', prev_theme, { desc = 'Previous theme' })
vim.keymap.set('n', '<leader>cr', random_theme, { desc = 'Random theme' })
vim.keymap.set('n', '<leader>cl', telescope_theme_selector, { desc = 'Select theme' })
vim.keymap.set('n', '<leader>cc', show_current_theme, { desc = 'Current theme' })

-- Apply the default theme on startup
apply_theme(current_theme)

-- Export functions for use in other files (optional)
M.next_theme = next_theme
M.prev_theme = prev_theme
M.set_theme = set_theme
M.random_theme = random_theme
M.list_themes = list_themes

return M
