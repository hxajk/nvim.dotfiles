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
vim.opt.tabstop = 4        -- Number of spaces for a tab
vim.opt.shiftwidth = 4     -- Spaces for auto-indent
vim.opt.expandtab = true   -- Convert tabs to spaces
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

-- Extras 

for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

local is_windows = vim.fn.has("win32") ~= 0

-- Key maps --------------------------------------------- 

vim.g.mapleader = " "

-- Insert mode mappings
vim.keymap.set('i', 'jj', '<ESC>', { desc = 'Turn to normal mode' })
vim.keymap.set('i', '<C-b>', '<ESC>^i', { desc = 'Beginning of line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'End of line' })


-- Normal mode mappings
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<CR>', { desc = 'Resize up' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<CR>', { desc = 'Resize down' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Resize left' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Resize right' })
vim.keymap.set('n', '<S-Down>', function()
  vim.api.nvim_feedkeys('5j', 'n', true)
end, { desc = 'Fast move down' })
vim.keymap.set('n', '<S-Up>', function()
  vim.api.nvim_feedkeys('5k', 'n', true)
end, { desc = 'Fast move up' })
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>|', '<cmd>vsplit<cr>', { desc = 'Vertical Split' })
vim.keymap.set('n', '<leader>\\', '<cmd>split<cr>', { desc = 'Horizontal Split' })

-- Visual mode mappings
vim.keymap.set('x', 'X', '"_x"', { desc = 'Delete all characters in line' })
vim.keymap.set('x', '>', '<gv', { desc = 'Indent line' })
vim.keymap.set('x', '<', '<gv', { desc = 'Unindent line' })

-- Terminal mode mappings 

vim.keymap.set('t',"<C-h>","<cmd>wincmd h<cr>", {desc = "Terminal left window navigation" })
vim.keymap.set('t',"<C-j>", "<cmd>wincmd j<cr>", {desc = "Terminal down window navigation" })
vim.keymap.set('t',"<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
vim.keymap.set('t',"<C-l>","<cmd>wincmd l<cr>", {desc = "Terminal right window navigation"})



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
        end
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
							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
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
})
