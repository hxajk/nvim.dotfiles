-- Tools plugins

local get_icons = require("core").get_icon

local default = {

    -- pleanary.nvim -> [A provider for various lua plugins]
    -- https://github.com/nvim-lua/plenary.nvim

	{
		"nvim-lua/plenary.nvim",
		lazy = true,
	},

    -- nvim-web-devicons -> [Adds file type icons to Vim plugins]
    -- https://github.com/ryanoasis/vim-devicons

	{
		"nvim-tree/nvim-web-devicons",
		enable = vim.g.icons_enabled,
		lazy = true,
	},

	-- persistence -> [Automated session for nvim]
    -- https://github.com/folke/persistence.nvim

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		lazy = true,
		opts = {},
		keys = {
			{
				"<leader>S",
				"<cmd><leader>S<cr>",
				desc = "+" .. get_icons("Session", 1, true) .. "Session",
			},
			{
				"<leader>Sa",
				[[<cmd>lua require("persistence").load()]],
				desc = "Load current session",
			},
			{ "<leader>Sb", [[<cmd>lua require("persistence").load({last = true})<cr>]], desc = "Load last session" },
			{
				"<leader>Sc",
				[[<cmd>lua require("persistence").stop()<cr>]],
				desc = "Stop session saved on exit",
			},
		},

		config = function(_, opts)
			require("persistence").setup(opts)
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
		cmd = {
			"ToggleTerm",
			"ToggleTermSetName",
			"ToggleTermToggleAll",
			"ToggleTermSendVisualLines",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualSelection",
		},
		opts = {
			on_open = function(_)
				-- Prevent infinite calls from freezing neovim.
				-- Only set these options specific to this terminal buffer.
				vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
				vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
			end,
			highlights = {
				Normal = { link = "Normal" },
				NormalNC = { link = "NormalNC" },
				NormalFloat = { link = "NormalFloat" },
				FloatBorder = { link = "FloatBorder" },
				StatusLine = { link = "StatusLine" },
				StatusLineNC = { link = "StatusLineNC" },
				WinBar = { link = "WinBar" },
				WinBarNC = { link = "WinBarNC" },
			},
			open_mapping = false,
			hide_numbers = true,
			shade_filetypes = {},
			float_opts = { border = "rounded" },
			shade_terminals = false,
			shading_factor = 2,
			start_in_insert = true,
			persist_mode = false,
			insert_mappings = true,
			persist_size = true,
			close_on_exit = true,
			shell = vim.o.shell,
		},

		keys = {
			{
				"<leader>t",
				"<Cmd><leader>t<CR>",
				desc = "+" .. get_icons("Terminal", 1, true) .. "Terminal",
			},
			{ "<leader>tt", "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal (float)" },
			{ "<leader>th", "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal (horizontal)" },
			{ "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle terminal (vertical)" },
		},

		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
	},

	-- Fuzzy Finder
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		cmd = { "Telescope", "Mason" },
		dependencies = {
			{
				"nvim-telescope/telescope-ui-select.nvim",
			},
		},
		opts = {
			pickers = {
				colorscheme = {
					enable_preview = true,
				},
			},
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/",
				},

				prompt_prefix = get_icons("TelescopePrompt", 1, true),
				selection_caret = "  ",
				initial_mode = "insert",
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.85,
					height = 0.92,
					preview_cutoff = 120,
				},
				path_display = { "truncate" },
				color_devicons = true,
				results_title = false,
				file_ignore_patterns = {
					".cache/**",
					"build/**",
					"bin/*",
					"node_modules",
				},
			},

			extensions = {},
		},

		keys = {
			{ "<leader>f", "<leader>f", desc = "+" .. get_icons("Telescope", 1, true) .. "Telescope" },
		},

		config = function(_, opts)

			require("telescope").setup(opts)
			require("telescope").load_extension("ui-select")

			vim.keymap.set("n", "<leader>fa", function()
				require("telescope.builtin").find_files({
					prompt_title = "Config Files",
					cwd = vim.fn.stdpath("config"),
					follow = true,
				}) -- call telescope
			end, { desc = "Find nvim config files" })

			-- Find Buffers
			vim.keymap.set("n", "<leader>fb", function()
				require("telescope.builtin").buffers()
			end, { desc = "Find Buffers" })

			-- Find help
			vim.keymap.set("n", "<leader>fh", function()
				require("telescope.builtin").help_tags()
			end, { desc = "Find help" })

			-- Find word in current buffer
			vim.keymap.set("n", "<leader>f/", function()
				require("telescope.builtin").current_buffer_fuzzy_find()
			end, { desc = "Find word in current buffer" })

			-- Find recent files
			vim.keymap.set("n", "<leader>fo", function()
				require("telescope.builtin").oldfiles()
			end, { desc = "Find recent" })

			-- Find all files
			vim.keymap.set("n", "<leader>ff", function()
				require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
			end, { desc = "Find all files" })

			-- Find themes
			vim.keymap.set("n", "<leader>ft", function()
				require("telescope.builtin").colorscheme({ enable_preview = true })
			end, { desc = "Find themes" })

			if vim.fn.executable("rg") == 1 then
				vim.keymap.set("n", "<leader>fw", function()
					require("telescope.builtin").live_grep()
				end, { desc = "Find Words" })
			end
		end,
	},
}

return default
