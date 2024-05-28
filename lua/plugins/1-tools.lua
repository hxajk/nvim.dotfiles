	----------------------------------- Tools Part ---------------------------------
local get_icons = require("core").get_icon

local default = {
    -- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },

	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		lazy = true,
		opts = {},
		keys = {
			{ "<leader>S", "<cmd><leader>S<cr>", desc = "+".. get_icons("Session",1,true) .. "Session" },
			{ "<leader>Sa", [[<cmd>lua require("persistence").load()]], desc = "Load current session" },
			{ "<leader>Sb", [[<cmd>lua require("persistence").load({last = true})<cr>]], desc = "Load last session" },
			{ "<leader>Sc", [[<cmd>lua require("persistence").stop()<cr>]], desc = "Stop session saved on exit" },
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
				Normal = {
					link = "Normal",
				},
				NormalFloat = {
					link = "NormalFloat",
				},
				FloatBorder = {
					link = "FloatBorder",
				},
			},
			open_mapping = false,
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = false,
			shading_factor = "1",
			start_in_insert = true,
			persist_mode = false,
			insert_mappings = true,
			persist_size = true,
			close_on_exit = true,
			shell = vim.o.shell,
		},

        keys = {
            { "<leader>t", "<Cmd><leader>t<CR>", desc = "t" .. get_icons("Terminal",1,true) .. "Terminal" },
            {"<leader>tt", "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal (float)"},
            {"<leader>th","<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal (horizontal)"},
            {"<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle terminal (vertical)"}
        },

		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
	},

	-- Fuzzy Finder
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		cmd = "Telescope",
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
				prompt_prefix = get_icons("TelescopePrompt",1,true),
				initial_mode = "insert",
				results_title = false,
				layout_strategy = "horizontal",
				path_display = { "absolute" },
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				color_devicons = true,
				selection_caret = "  ",
				file_ignore_patterns = {
					".git/*",
					".cache/**",
					"build/**",
					"%.class",
					"%.pdf",
					"%.mkv",
					"%.mp4",
					"%.zip",
					"*.o",
					"*.exe",
					"bin/*",
				},
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
			},
			extensions = {},
		},

		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("ui-select")

			vim.keymap.set("n", "<leader>f", "<leader>f", { desc = "+" .. get_icons("Telescope",1,true) .. "Telescope" })

			vim.keymap.set("n", "<leader>fa", function()
				local cwd = vim.fn.stdpath("config") .. "/.."
				local search_dirs = { vim.fn.stdpath("config") }
				if #search_dirs == 1 then
					cwd = search_dirs[1]
				end -- if only one directory, focus cwd
				require("telescope.builtin").find_files({
					prompt_title = "Config Files",
					cwd = cwd,
				}) -- call telescope
			end, { desc = "Find nvim config files" })

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
				pcall(vim.api.nvim_command, "doautocmd User LoadColorSchemes")
				pcall(require("telescope.builtin").colorscheme, { enable_preview = true })
			end, { desc = "Find themes" })
		end,
	},
}


return default
