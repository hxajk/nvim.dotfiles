-- Options Settings

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
vim.opt.sidescrolloff = 8
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

-- Time settings
vim.opt.timeoutlen = 300

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
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.icons_enabled = true
vim.g.autoformat = false
-- Extras

-- disable some default providers
vim.g["loaded_node_provider"] = 0
vim.g["loaded_python3_provider"] = 0
vim.g["loaded_perl_provider"] = 0
vim.g["loaded_ruby_provider"] = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

require("custom.options")
