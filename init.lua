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

-- Options

-- Clipboard setup based on environment
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- Completion options
vim.opt.completeopt = "menu,menuone,noselect"

-- Display options
vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

-- Indentation and tabs
vim.opt.tabstop = 4 -- Number of spaces for a tab
vim.opt.shiftwidth = 4 -- Spaces for auto-indent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart indentation

-- File handling
vim.opt.autowrite = true
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.undofile = true

-- Folding
vim.opt.foldlevel = 99
vim.opt.foldmethod = vim.fn.has("nvim-0.10") == 1 and "expr" or "indent"
vim.opt.foldtext = vim.fn.has("nvim-0.10") == 1 and "" or vim.opt.foldtext

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Scrolling and wrapping
vim.opt.wrap = false
vim.opt.scrolloff = 10

-- Mouse settings
vim.opt.mouse = "a" -- Enable mouse mode; set to "" to disable
-- vim.opt.guicursor = "" -- Enable blocky cursor

-- Virtual editing
vim.opt.virtualedit = "block"

-- Smooth scrolling (available in Neovim 0.10 and above)
if vim.fn.has("nvim-0.10") == 1 then
	vim.opt.smoothscroll = true
end

-- Editor settings
vim.cmd("set autoindent")
vim.cmd("set smarttab")
vim.cmd("set ve+=onemore")
vim.cmd("set updatetime=500")

-- Global Variables
vim.g.big_file = { size = 1024 * 100, lines = 10000 } -- For files bigger than 100KB
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.g.icons_enabled = true
vim.g.autoformat = false

-- Extras

for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

local is_windows = vim.fn.has("win32") ~= 0

-- Key maps ---------------------------------------------

vim.g.mapleader = " "

-- Insert mode mappings
vim.keymap.set("i", "jj", "<ESC>", { desc = "Turn to normal mode" })
vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })

-- Normal mode mappings
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize up" })
    vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize down" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })
vim.keymap.set("n", "<S-Down>", function()
	vim.api.nvim_feedkeys("5j", "n", true)
end, { desc = "Fast move down" })
vim.keymap.set("n", "<S-Up>", function()
	vim.api.nvim_feedkeys("5k", "n", true)
end, { desc = "Fast move up" })
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- Visual mode mappings
vim.keymap.set("x", "X", '"_x"', { desc = "Delete all characters in line" })
vim.keymap.set("x", ">", "<gv", { desc = "Indent line" })
vim.keymap.set("x", "<", "<gv", { desc = "Unindent line" })

-- Terminal mode mappings

vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })

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
                { "<S-Enter>",  function() noice.redirect(vim.fn.getcmdline()) end,                 { desc = "Redirect Cmdline" } },
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

		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
	},

	-- Fuzzy Finder
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
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
				"vimdoc",
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
        event = "User Lazy",
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
            local icons = 
{
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TabNine       = " ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",            
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

})
