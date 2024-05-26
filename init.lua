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


vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

vim.opt.completeopt = "menu,menuone,noselect"

vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true



-- File handling
vim.opt.autowrite = true
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.undofile = true


-- Indentation and tabs
vim.opt.tabstop = 4        -- Number of spaces for a tab
vim.opt.shiftwidth = 4     -- Spaces for auto-indent
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart indentation

-- Mouse settings
vim.opt.mouse = "a" -- Enable mouse mode; set to "" to disable
vim.opt.guicursor = "" -- Enable blocky cursor

-- Virtual editing
vim.opt.virtualedit = "block"


-- Editor settings
vim.cmd("set autoindent")
vim.cmd("set smarttab")
vim.cmd("set ve+=onemore")
vim.cmd("set updatetime=500")


for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
