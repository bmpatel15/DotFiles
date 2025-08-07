return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8", -- Use stable version
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "andrew-george/telescope-themes",
  },
  event = "VimEnter", -- Load on startup
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    -- Setup telescope first
    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          additional_args = function(opts)
            return { "--hidden" }
          end,
        },
      },
      extensions = {
        themes = {
          enable_previewer = true,
          enable_live_preview = true,
          persist = {
            enabled = true,
            path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
          },
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- Load extensions after setup
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "themes")

    -- Keymaps
    local map = vim.keymap.set
    
    -- File pickers
    map('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    map('n', '<leader>fa', function()
      builtin.find_files({ hidden = true, no_ignore = true })
    end, { desc = 'Find All Files (including hidden)' })
    map('n', '<leader>fr', builtin.oldfiles, { desc = 'Find Recent Files' })
    map('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
    
    -- Text search
    map('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
    map('n', '<leader>fw', builtin.grep_string, { desc = 'Find Word under cursor' })
    map('n', '<leader>fs', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = 'Find String' })
    
    -- Git pickers
    map('n', '<leader>gc', builtin.git_commits, { desc = 'Git Commits' })
    map('n', '<leader>gb', builtin.git_branches, { desc = 'Git Branches' })
    map('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })
    map('n', '<leader>gf', builtin.git_files, { desc = 'Git Files' })
    
    -- LSP pickers
    map('n', '<leader>lr', builtin.lsp_references, { desc = 'LSP References' })
    map('n', '<leader>ld', builtin.lsp_definitions, { desc = 'LSP Definitions' })
    map('n', '<leader>lt', builtin.lsp_type_definitions, { desc = 'LSP Type Definitions' })
    map('n', '<leader>li', builtin.lsp_implementations, { desc = 'LSP Implementations' })
    map('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'LSP Document Symbols' })
    map('n', '<leader>lw', builtin.lsp_workspace_symbols, { desc = 'LSP Workspace Symbols' })
    
    -- Diagnostics
    map('n', '<leader>dd', builtin.diagnostics, { desc = 'Diagnostics' })
    
    -- Help and documentation
    map('n', '<leader>hh', builtin.help_tags, { desc = 'Help Tags' })
    map('n', '<leader>hm', builtin.man_pages, { desc = 'Man Pages' })
    map('n', '<leader>hk', builtin.keymaps, { desc = 'Keymaps' })
    map('n', '<leader>hc', builtin.commands, { desc = 'Commands' })
    map('n', '<leader>ho', builtin.vim_options, { desc = 'Vim Options' })
    
    -- Telescope meta
    map('n', '<leader>tb', builtin.builtin, { desc = 'Telescope Builtin' })
    map('n', '<leader>tr', builtin.resume, { desc = 'Telescope Resume' })
    map('n', '<leader>tp', builtin.pickers, { desc = 'Telescope Previous Pickers' })
    
    -- Current buffer fuzzy find
    map('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = 'Fuzzy search in current buffer' })
    
    -- Live grep in open files
    map('n', '<leader>f/', function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      })
    end, { desc = 'Live Grep in Open Files' })
    
    -- Search Neovim config files
    map('n', '<leader>fn', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = 'Find Neovim config files' })
    
    -- Search Obsidian vault (your custom path)
    map('n', '<leader>fo', function()
      builtin.find_files({ cwd = '~/Documents/Bhavesh_Zettlekasten/' })
    end, { desc = 'Find Obsidian files' })
    
    -- Theme switcher
    map('n', '<leader>th', '<cmd>Telescope themes<CR>', { desc = 'Theme Switcher' })
    
    -- Quick access (commonly used)
    map('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })
    map('n', '<C-p>', builtin.find_files, { desc = 'Find Files (Ctrl-P style)' })
    
  end,
}
