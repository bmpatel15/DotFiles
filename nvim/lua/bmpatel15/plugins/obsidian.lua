return {
  'obsidian-nvim/obsidian.nvim',
  config = function()
    require('obsidian').setup {
      legacy_commands = false,
      workspaces = {
        {
          name = 'Bhavesh',
          path = '/Users/bmpatel15/Documents/Bhavesh_Zettlekasten/',
        },
      },
      notes_subdir = 'Daily Notes',
      new_notes_location = 'notes_subdir',
      disable_frontmatter = true,
      templates = {
        subdir = 'Templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M:%S',
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      -- Set conceallevel for markdown files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.opt_local.conceallevel = 2
        end,
      }),
      -- name new notes starting the ISO datetime and ending with note name
      -- put them in the inbox subdir
      -- note_id_func = function(title)
      --   local suffix = ""
      --   -- get current ISO datetime with -5 hour offset from UTC for EST
      --   local current_datetime = os.date("!%Y-%m-%d-%H%M%S", os.time() - 5*3600)
      --   if title ~= nil then
      --     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      --   else
      --     for _ = 1, 4 do
      --       suffix = suffix .. string.char(math.random(65, 90))
      --     end
      --   end
      --   return current_datetime .. "_" .. suffix
      -- end,
      -- key mappings, below are the defaults

      -- },
      -- ui = {
      --   -- Disable some things below here because I set these manually for all Markdown files using treesitter
      --   checkboxes = {},
      --   bullets = {},
      -- },
    }
  end,
}
