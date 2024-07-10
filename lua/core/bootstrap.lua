-- Bootstrap core

local M = {}

local icons = {
	misc = require("core.icons").gets("misc"),
	ui = require("core.icons").gets("ui"),
}

--- @brief Install lazy.vim, generate custom  for the first time, and us.
--- @param installpath string
M.init = function(installpath)
	vim.notify("Loading package manager... ⏱")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		installpath,
	})
	M.gen_template()
end

--- @brief Generate custom template for us.
M.gen_template = function()
	local path = vim.fn.stdpath("config") .. "/lua/custom"

	if vim.fn.isdirectory(path) == 1 then
		return
	end

	vim.fn.mkdir(path, "p")

	local files = {
		["options.lua"] = [[
-- Add additonal option here



]],
		["plugins.lua"] = [[
-- Add additional plugin here

local default = {

}

return default
]],
		["keymaps.lua"] = [[
-- Add additional keymap here 



]],
	}

	for filename, content in pairs(files) do
		local file = io.open(path .. "/" .. filename, "w")
		if file then
			file:write(content)
			file:close()
		end
	end
end

--- @brief Loading lazy.vim, related core settings for greater 1 time.
--- @param installpath string
M.load = function(installpath)
	vim.opt.rtp:prepend(installpath)

	require("core.options")

	require("lazy").setup({
		spec = {
			{ import = "plugins" },
		},

		ui = {
			border = "rounded",
			size = { width = 0.88, height = 0.8 },
			wrap = true,
			icons = {
				cmd = icons.misc.Code,
				config = icons.ui.Gear,
				init = icons.misc.ManUp,
				keys = icons.ui.Keyboard,
				loaded = icons.ui.Check,
				not_loaded = icons.misc.Ghost,
				plugin = icons.ui.Package,
				runtime = icons.misc.Vim,
				start = icons.ui.Play,
			},
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
				--download faster from the plugin repos.
				disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
			},
		},
	})

	-- Defer non-critical operations
	vim.defer_fn(function()
		require("core.keymaps")
	end, 0)
end

return M
