--  More coding plugins

local get_icons = require("core").gets

local default = {
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
				add = { text = get_icons("base").GitAdd },
				change = { text = get_icons("base").GitChange },
				delete = { text = get_icons("base").GitDelete },
				topdelete = { text = get_icons("base").GitTopDelete },
				changedelete = { text = get_icons("base").GitChangeDelete },
				untracked = { text = get_icons("base").GitUnTracked },
			},
			on_attach = function(_)
				local gs = package.loaded.gitsigns

                -- stylua: ignore start
                vim.keymap.set('n', '<leader>g', '<leader>g', { desc = "+" .. get_icons("base").Git .. "Git" })
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
}

return default
