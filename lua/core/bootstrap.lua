local M = {}

M.init = function(installpath)
    
    vim.notify("  Installing lazy.nvim & plugins ...")

	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		installpath,
	})

end

M.load = function(installpath)
	vim.opt.rtp:prepend(installpath)
    
    require("core.options")

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

	-- Defer non-critical operations
	vim.defer_fn(function()
		require("core.keymaps")
	end, 0)
end

return M
