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

-- Normal mode mappings
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<CR>', { desc = 'Resize up' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<CR>', { desc = 'Resize down' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Resize left' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Resize right' })
vim.keymap.set('n', '[b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', ']b', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '<S-Down>', function()
  vim.api.nvim_feedkeys('5j', 'n', true)
end, { desc = 'Fast move down' })
vim.keymap.set('n', '<S-Up>', function()
  vim.api.nvim_feedkeys('5k', 'n', true)
end, { desc = 'Fast move up' })
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>|', '<cmd>vsplit<cr>', { desc = 'Vertical Split' })
vim.keymap.set('n', '<leader>\\', '<cmd>split<cr>', { desc = 'Horizontal Split' })
