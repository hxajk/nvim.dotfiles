--
--        _   _       _                  _____             __ _
--       | \ | |     (_)                / ____|           / _(_)
--       |  \| |_   ___ _ __ ___       | |     ___  _ __ | |_ _  __ _
--       | . ` \ \ / / | '_ ` _ \      | |    / _ \| '_ \|  _| |/ _` |
--       | |\  |\ V /| | | | | | |     | |___| (_) | | | | | | | (_| |
--       |_| \_| \_/ |_|_| |_| |_|      \_____\___/|_| |_|_| |_|\__, |
--                                                               __/ |
--                                                              |___/

-- Author: hxajk (hxajkzzz@gmail.com).
-- Update: 2024-05-30 18:41:00

require("core.options")


require("core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy_conf = {

    ui = {
			border = "rounded",
			title = "Plugin Manager",
			title_pos = "center",
		},

		performance = {
			cache = {
				enabled = true,
				path = vim.fn.stdpath("cache") .. "/lazy/cache",
				disable_events = { "UIEnter", "BufReadPre" },
				ttl = 3600 * 24 * 2,
			},
			reset_packpath = true,
			rtp = {
				reset = true,
				---@type string[]
				paths = {},
			},
		},
	}

require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		config = function()
			vim.cmd("colorscheme tokyonight")
		end,
	},
	{
		{
			"nvimdev/dashboard-nvim",
			event = "BufWinEnter",
			lazy = true,
			opts = function()
				local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
            ]]

				logo = string.rep("\n", 8) .. logo .. "\n\n"

				local opts = {
					theme = "doom",
					hide = {
						statusline = false,
					},
					config = {
						header = vim.split(logo, "\n"),
                    -- stylua: ignore
                    center = {
                        { action = "Telescope find_files", desc = " Find File", icon = " ", key = "f" },
                        { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
                        { action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
                        { action = "Telescope colorscheme", desc = " Change Background", icon = " ", key = "t" },
                        { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
                        { action = 'e $MYVIMRC', desc = " Configuration", icon = " ", key = "c" },
                        { action = "qa", desc = " Quit Neovim", icon = " ", key = "q" },
                    },
						footer = function()
							local stats = require("lazy").stats()
							local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
							return {
								"⚡ Neovim loaded "
									.. stats.loaded
									.. "/"
									.. stats.count
									.. " plugins in "
									.. ms
									.. "ms",
							}
						end,
					},
				}

				for _, button in ipairs(opts.config.center) do
					button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
					button.key_format = "  %s"
				end

				return opts
			end,
		},
	},

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
	{
		"akinsho/bufferline.nvim",
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
			},
		},
		keys = {
			{ "<leader>b", "<Cmd><leader>b<CR>", desc = "+󰓩 Buffer" },
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
			{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		},
		config = function(_, opts)
			vim.opt.termguicolors = true
			require("bufferline").setup(opts)
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		init = function()
			if vim.fn.argc(-1) > 0 then
				vim.o.statusline = " "
			else
				vim.o.laststatus = 0
			end
		end,

		opts = function()
			return {
				options = {
					theme = "tokyonight",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
				},
				sections = {
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
			}
		end,

		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},

	{
		"rcarriga/nvim-notify",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("notify").setup({
				stages = "fade",
				timeout = 3000,
				max_height = function()
					return math.floor(vim.o.lines * 0.75)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.75)
				end,
				on_open = function(win)
					vim.api.nvim_win_set_config(win, { zindex = 100 })
				end,
			})
			vim.notify = require("notify")
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		lazy = true,
		dependencies = {
			{ "MunifTanjim/nui.nvim", lazy = true },
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
			},
		},
        -- stylua: ignore
        config = function(_, opts)
            local noice = require("noice")
            local noice_lsp = require("noice.lsp")
            noice.setup(opts)

            local mappings = {
                { "<S-Enter>",  function() noice.redirect(vim.fn.getcmdline()) end, { desc = "Redirect Cmdline" } },
                { "<leader>s", "<leader>s", { desc = "+ Notification" } },
                { "<leader>sl", function() noice.cmd("last") end,                                   { desc = "Noice Last Message" } },
                { "<leader>sh", function() noice.cmd("history") end,                                { desc = "Noice History" } },
                { "<leader>sa", function() noice.cmd("all") end,                                    { desc = "Noice All" } },
                { "<leader>sd", function() noice.cmd("dismiss") end,                                { desc = "Dismiss All" } },
                { "<leader>st", function() noice.cmd("telescope") end,                              { desc = "Noice Telescope" } },
                { "<c-f>",      function() if not noice_lsp.scroll(4) then return "<c-f>" end end,  { silent = true, expr = true, desc = "Scroll Forward" } },
                { "<c-b>",      function() if not noice_lsp.scroll(-4) then return "<c-b>" end end, { silent = true, expr = true, desc = "Scroll Backward" } },
            }

            for _, map in ipairs(mappings) do
                vim.keymap.set("n", map[1], map[2], map[3])
            end
        end,
	},
	{
		"folke/which-key.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		init = function() end,
		opts = {
			disable = { filetypes = { "TelescopePrompt" } },
			layout = {
				height = { min = 3, max = 25 },
				align = "center",
			},
			window = {
				border = "none",
				position = "bottom",
				margin = { 1, 0, 1, 0 },
				padding = { 1, 1, 1, 1 },
				winblend = 0,
			},
		},
		config = function(_, opts)
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup(opts)
		end,
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },

	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		lazy = true,
		opts = {},
		keys = {
			{ "<leader>S", "<cmd><leader>S<cr>", desc = "+ Session" },
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
		lazy = false,
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

		config = function(_, opts)
			require("toggleterm").setup(opts)
			vim.keymap.set("n", "<leader>t", "<Cmd><leader>t<cr>", { desc = "+ Terminal" })
			vim.keymap.set(
				"n",
				"<leader>tt",
				"<cmd>ToggleTerm direction=float<cr>",
				{ desc = "Toggle terminal (float)" }
			)
			vim.keymap.set(
				"n",
				"<leader>th",
				"<cmd>ToggleTerm direction=horizontal<cr>",
				{ desc = "Toggle terminal (horizontal)" }
			)
			vim.keymap.set(
				"n",
				"<leader>tv",
				"<cmd>ToggleTerm direction=veritcal<cr>",
				{ desc = "Toggle terminal (vertical)" }
			)
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
				prompt_prefix = "  ",
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

			vim.keymap.set("n", "<leader>f", "<leader>f", { desc = "+ Telescope" })

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

	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			if #vim.api.nvim_list_uis() ~= 0 then
				vim.api.nvim_command([[TSUpdate]])
			end
		end,
		event = "BufReadPre",
		lazy = true,
		version = false,
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		opts = {
			hightlight = {
				enable = true,
				disable = { "help" },
			},
			indent = { enable = true },

			ensure_installed = {
				"markdown",
				"vim",
				"lua",
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		-- LSP and Autocompletion
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		opts = function()
			return {
				underline = true,
				severity_sort = true,
				update_in_insert = false,
				diagnostic = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
					},
					severity_sort = true,
				},
			}
		end,
		config = function(_, opts)
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = { "clangd", "pyright" }

			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup({
					on_attach = function(client, buffer) end,

					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				})
			end

			require("lspconfig").lua_ls.setup({
				on_attach = function(client, buffer) end,

				capabilities = require("cmp_nvim_lsp").default_capabilities(),

				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
			vim.keymap.set("n", "<leader>l", "<leader>l", { desc = "+ LSP" })
			vim.keymap.set("n", "<leader>lu", function()
				vim.g.autoformat = not vim.g.autoformat

				if vim.g.autoformat then
					vim.notify("Enable Auto Format")
				else
					vim.notify("Disable Auto Format")
				end
			end, { desc = "Toggle autoformat" })

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					if vim.g.autoformat then
						require("conform").format({ bufnr = args.buf })
					end
				end,
			})
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		event = "VeryLazy",
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		lazy = true,
		event = "InsertEnter",
		version = false,
		opts = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local icons = {
				Array = " ",
				Boolean = "󰨙 ",
				Class = " ",
				Codeium = "󰘦 ",
				Color = " ",
				Control = " ",
				Collapsed = " ",
				Constant = "󰏿 ",
				Constructor = " ",
				Copilot = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Folder = " ",
				Function = "󰊕 ",
				Interface = " ",
				Key = " ",
				Keyword = " ",
				Method = "󰊕 ",
				Module = " ",
				Namespace = "󰦮 ",
				Null = " ",
				Number = "󰎠 ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				Reference = " ",
				Snippet = " ",
				String = " ",
				Struct = "󰆼 ",
				TabNine = " ",
				Text = " ",
				TypeParameter = " ",
				Unit = " ",
				Value = " ",
				Variable = "󰀫 ",
			}

			return {
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},

				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(_, item)
						-- Kind icons
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end

						return item
					end,
				},
				mapping = {
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			}
		end,

		config = function(_, opts)
			local cmp = require("cmp")

			cmp.setup(opts)
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		lazy = true,
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_uninstalled = "✗",
					package_pending = "⟳",
				},
			},
		},
		config = function(_, opts)
			local ensure_installed = { "lua-language-server", "stylua" }

			require("mason").setup(opts)

			vim.api.nvim_create_user_command("MasonInstallAll", function()
				if ensure_installed and #ensure_installed > 0 then
					vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
				end
			end, {})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		lazy = true,
		opts = {
			check_ts = true,
			ts_config = { java = false },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)

			require("cmp").event:on(
				"confirm_done",
				require("nvim-autopairs.completion.cmp").on_confirm_done({ tex = false })
			)
		end,
	},

	{
		"numToStr/Comment.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },

		keys = {
			{ "gcc", mode = "n", desc = "comment toggle current line" },
			{ "gc", mode = { "n", "o" }, desc = "comment toggle linewise" },
			{ "gc", mode = "x", desc = "comment toggle linewise (visual)" },
			{ "gbc", mode = "n", desc = "comment toggle current block" },
			{ "gb", mode = { "n", "o" }, desc = "comment toggle blockwise" },
			{ "gb", mode = "x", desc = "comment toggle blockwise (visual)" },
		},

		opts = {},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		enabled = vim.fn.executable("git") == 1,

		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

            -- stylua: ignore start 
            vim.keymap.set('n', '<leader>g', '<leader>g', { desc = '+ Git' })
            vim.keymap.set('n', ']h', function() gs.nav_hunk("next") end, { desc = 'Next Hunk' })
            vim.keymap.set('n', '[h', function() gs.nav_hunk("prev") end, { desc = 'Prev Hunk' })
            vim.keymap.set('n', ']H', function() gs.nav_hunk("last") end, { desc = 'Last Hunk' })
            vim.keymap.set('n', '[H', function() gs.nav_hunk("first") end, { desc = 'First Hunk' })
            vim.keymap.set({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage Hunk' })
            vim.keymap.set({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset Hunk' })
            vim.keymap.set('n', '<leader>gS', gs.stage_buffer, { desc = 'Stage Buffer' })
            vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
            vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset Buffer' })
            vim.keymap.set('n', '<leader>gp', gs.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
            vim.keymap.set('n', '<leader>gb', function() gs.blame_line({ full = true }) end, { desc = 'Blame Line' })
            vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = 'Diff This' })
            vim.keymap.set('n', '<leader>gD', function() gs.diffthis("~") end, { desc = 'Diff This ~' })
            vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'GitSigns Select Hunk' })   
			end,
		},
	},
}, lazy_conf)
