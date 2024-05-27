
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
		spec = {
			{ import = "plugins" },
		},

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
	})
