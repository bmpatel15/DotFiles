return {
	-- Mini Nvim
	{ "echasnovski/mini.nvim", version = false },
	-- Comments
	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- disable the autocommand from ts-context-commentstring
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})

			require("mini.comment").setup({
				-- tsx, jsx, html , svelte comment support
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring({
							key = "commentstring",
						}) or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	-- File explorer (this works properly with oil unlike nvim-tree)
	{
		"echasnovski/mini.files",
		config = function()
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				mappings = {
					go_in = "<CR>", -- Map both Enter and L to enter directories or open files
					go_in_plus = "L",
					go_out = "-",
					go_out_plus = "H",
				},
			})
			vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" }) -- toggle file explorer
			vim.keymap.set("n", "<leader>ef", function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
				MiniFiles.reveal_cwd()
			end, { desc = "Toggle into currently opened file" })
		end,
	},
	-- Surround (your config is good, just added some custom surroundings)
	{
		"echasnovski/mini.surround",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			custom_surroundings = {
				-- Custom surroundings for Markdown
				["*"] = { output = { left = "**", right = "**" } }, -- Markdown bold
				["_"] = { output = { left = "_", right = "_" } }, -- Markdown italic
				["`"] = { output = { left = "`", right = "`" } }, -- Markdown code
				["~"] = { output = { left = "~~", right = "~~" } }, -- Markdown strikethrough
				["="] = { output = { left = "==", right = "==" } }, -- Markdown highlight
				["i"] = { output = { left = "*", right = "*" } }, -- Markdown italic (alternative)
				["f"] = { -- Function call
					input = { "%w+%(.-%)" },
					output = { left = "", right = "()" },
				},
				["t"] = { -- HTML/XML tag
					input = { "<(%w-)%f[^<%w][^<>]->.-</%1>" },
					output = function()
						local tag = require("mini.surround").user_input("Tag name: ")
						if tag then
							return { left = "<" .. tag .. ">", right = "</" .. tag .. ">" }
						end
					end,
				},
			},
			highlight_duration = 300,
			mappings = {
				add = "sa",
				delete = "ds",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",
				suffix_last = "l",
				suffix_next = "n",
			},
			n_lines = 20,
			respect_selection_type = false,
			search_method = "cover",
			silent = false,
		},
	},

	-- Get rid of whitespace
	{
		"echasnovski/mini.trailspace",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local miniTrailspace = require("mini.trailspace")

			miniTrailspace.setup({
				only_in_normal_buffers = true,
			})
			vim.keymap.set("n", "<leader>cw", function()
				miniTrailspace.trim()
			end, { desc = "Erase Whitespace" })

			-- Ensure highlight never reappears by removing it on CursorMoved
			vim.api.nvim_create_autocmd("CursorMoved", {
				pattern = "*",
				callback = function()
					require("mini.trailspace").unhighlight()
				end,
			})
		end,
	},
	-- Split & join
	{
		"echasnovski/mini.splitjoin",
		config = function()
			local miniSplitJoin = require("mini.splitjoin")
			miniSplitJoin.setup({
				mappings = { toggle = "" }, -- Disable default mapping
			})
			vim.keymap.set({ "n", "x" }, "sj", function()
				miniSplitJoin.join()
			end, { desc = "Join arguments" })
			vim.keymap.set({ "n", "x" }, "sk", function()
				miniSplitJoin.split()
			end, { desc = "Split arguments" })
		end,
	},
}
