	--------------------- User Interface (UI) Part -------------------------------
local get_icons = require("core").get_icon

return {
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
			{ "<leader>b", "<Cmd><leader>b<CR>", desc = "+" .. get_icons("Buffer",1,true) .. "Buffer" },
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
                { "<leader>s", "<leader>s", { desc = "+" .. get_icons("Message",1,true) ..  "Notification" } },
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
}
