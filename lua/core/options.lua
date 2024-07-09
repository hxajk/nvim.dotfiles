-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-----------------------------------------------------------
-- General Neovim options and configuration
-----------------------------------------------------------

local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-- General

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.completeopt = "menuone,noinsert,noselect"

-- Neovim UI

opt.number = true
opt.showmatch = true
opt.foldmethod = "marker"
opt.colorcolumn = "80"
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.linebreak = true
opt.termguicolors = true
opt.laststatus = 3

-- Tabs, indent

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Memory

opt.hidden = true
opt.history = 100
opt.lazyredraw = true
opt.synmaxcol = 240
opt.updatetime = 250
opt.undofile = true

------------------------------------------------------------
-- Configuration
-----------------------------------------------------------

-- Global Variables
vim.g.icons_enabled = true
vim.g.autoformat = false
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable builtin plugins
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- Set global variable
local is_windows = vim.fn.has("win32") ~= 0

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

require("custom.options")
