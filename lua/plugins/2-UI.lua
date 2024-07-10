-- UI Plugins

local core = require("core.icons")
local icons = {
	ui = core.gets("ui"),
	git = core.gets("git"),
	diagnostics = core.gets("diagnostics"),
	misc = core.gets("misc"),
	tools = core.gets("tools"),
}

local default = {

	-- catppuccin/nvim -> [A Soothing pastel theme for (Neo)vim]
	-- https://github.com/catppuccin/nvim

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			background = { light = "latte", dark = "mocha" },
			transparent_background = false,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			show_end_of_buffer = false,
			term_colors = true,
			compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
			styles = {
				comments = { "bold" },
				functions = { "bold" },
				keywords = { "bold" },
				operators = { "bold" },
				conditionals = { "bold" },
				loops = { "bold" },
				booleans = { "bold", "italic" },
				numbers = {},
				types = {},
				strings = {},
				variables = {},
				properties = {},
			},
			integrations = {
				treesitter = true,
				alpha = false,
				notify = true,
				cmp = true,
				dashboard = false,
				gitsigns = true,
				indent_blankline = { enabled = true, colored_indent_levels = true },
				markdown = true,
				mason = true,
				telescope = { enabled = true, style = "nvchad" },
			},
			color_overrides = {},
			highlight_overrides = {
				all = function(cp)
					return {
						CursorLineNr = { fg = cp.green },

						WhichKeyBorder = { fg = cp.red },

						NoiceCmdlinePopupBorder = { fg = cp.teal },
						NoiceCmdlineIcon = { fg = cp.teal },
						NoiceCmdlinePopupTitle = { fg = cp.teal },

						["@keyword.return"] = { fg = cp.pink, style = {} },
						["@error.c"] = { fg = cp.none, style = {} },
						["@error.cpp"] = { fg = cp.none, style = {} },
					}
				end,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			require("catppuccin").load()
		end,
	},

	-- mini.indentscope -> [Neovim Lua plugin to visualize and operate on indent scope]
	-- https://github.com/echasnovski/mini.indentscope

	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	-- bufferline.nvim -> [A snazzy bufferline for Neovim]
	-- https://github.com/akinsho/bufferline.nvim

	{
		"akinsho/bufferline.nvim",
		tags = "*",
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = {
			options = {
				number = nil,
				buffer_close_icon = icons.ui.Close,
				left_trunc_marker = icons.ui.Left,
				right_trunc_marker = icons.ui.Right,
				max_name_length = 20,
				max_prefix_length = 13,
				tab_size = 20,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				enforce_regular_tabs = false,
				persist_buffer_sort = true,
				always_show_bufferline = true,
				separator_style = "thin",
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(_, _, diagnostics, _)
					local result = {}

					local symbols = {
						error = icons.diagnostics.Error,
						warning = icons.diagnostics.Warning,
						info = icons.diagnostics.Information,
					}
					for name, count in pairs(diagnostics) do
						if symbols[name] and count > 0 then
							table.insert(result, symbols[name] .. " " .. count)
						end
					end
					result = table.concat(result, " ")
					return #result > 0 and result or ""
				end,

				highlights = {

					styles = { "bold" },
				},
			},
		},
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Buffer: Toggle Pin" },
			{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Buffer: Delete " },
			{ "<leader>be", "<Cmd>BufferLineSortByExtension<CR>", desc = "Buffer: Sort by extensions" },
			{ "<leader>bd", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Buffer: Sort by directory" },

			{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Buffer: Next" },
			{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Buffer: Prev" },
		},
		config = function(_, opts)
			vim.opt.termguicolors = true
			require("bufferline").setup(opts)
		end,
	},

	-- feline.nvim -> [A blazing fast and easy to configure neovim statusline plugin]
	-- https://github.com/nvim-lualine/lualine.nvim

	{
		"freddiehaddad/feline.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },

		opts = function()
			local colors = require("core.colors").catppuccin

			local vi_mode_colors = {
				NORMAL = colors.cyan,
				INSERT = colors.green,
				VISUAL = colors.yellow,
				OP = colors.cyan,
				BLOCK = colors.cyan,
				REPLACE = colors.red,
				["V-REPLACE"] = colors.red,
				ENTER = colors.orange,
				MORE = colors.orange,
				SELECT = colors.yellow,
				COMMAND = colors.pink,
				SHELL = colors.pink,
				TERM = colors.pink,
				NONE = colors.yellow,
			}

			return {
				vi_mode_colors = vi_mode_colors,
				force_inactive = {
					filetypes = {
						"^NvimTree$",
						"^packer$",
						"^vista$",
						"^help$",
					},
					buftypes = {
						"^terminal$",
					},
				},
			}
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		lazy = true,

		keys = {
			{ "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Navigation: Toggle" },
		},

		opts = {},

		config = function(_, opts)
			require("nvim-tree").setup(opts)
		end,
	},

	-- nvim-scrollview -> [Displays interactive vertical scrollbars and signs]
	-- https://github.com/dstein64/nvim-scrollview

	{
		"dstein64/nvim-scrollview",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = function()
			require("scrollview").setup({
				mode = "virtual",
				excluded_filetypes = { "NvimTree", "terminal", "nofile", "aerial" },
				winblend = 0,
				signs_on_startup = { "diagnostics", "folds", "marks", "search", "spell" },
				diagnostics_error_symbol = icons.diagnostics.Error,
				diagnostics_warn_symbol = icons.diagnostics.Warning,
				diagnostics_info_symbol = icons.diagnostics.Information,
				diagnostics_hint_symbol = icons.diagnostics.Hint,
			})
		end,
	},

	-- which-key.nvim -> [Displays a popup with possible keybindings of the command you started typing.]
	-- https://github.com/folke/which-key.nvim

	{
		"folke/which-key.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		opts = {
			plugins = {
				presets = {
					operators = false,
					motions = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = true,
					g = true,
				},
			},
			disable = { filetypes = { "TelescopePrompt" } },
			icons = {
				breadcrumb = icons.ui.Separator,
				separator = icons.misc.Vbar,
				group = "",
			},
			window = {
				position = "bottom",
				margin = { 1, 0, 1, 0 },
				padding = { 1, 1, 1, 1 },
				winblend = 0,
			},
		},
		config = function(_, opts)
			require("which-key").register({
				["<leader>"] = {
					b = {
						name = icons.ui.Buffer .. " Buffer",
					},
					f = {
						name = icons.ui.Telescope .. " Search",
					},
					g = {
						name = icons.git.Git .. " Git",
					},
					l = {
						name = icons.misc.LSP .. " Language Server Protocol",
					},
					t = {
						name = icons.tools.Terminal .. " Terminal",
					},
					p = {
						name = icons.misc.Package .. " Package",
					},
					s = {
						name = icons.tools.Session .. " Session",
					},
				},
			})

			require("which-key").setup(opts)
		end,
	},
}

return default
