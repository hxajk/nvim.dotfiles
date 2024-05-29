-- Bootstrap core 

local M = {}

M.init = function(installpath)
	vim.notify("Waiting...")
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

-- Function to generate a template configuration
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
