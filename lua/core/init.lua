-- Main core (extra stuffs)

local M = {}

M.notify = function(msg, type, opts)
	vim.schedule(function()
		vim.notify(msg, type, vim.tbl_deep_extend("force", { title = "3x3y3z" }, opts or {}))
	end)
end

M.is_available = function(plugin)
	local status, lazy = pcall(require, "lazy.core.config")
	return status and lazy.spec.plugins[plugin] ~= nil
end

M.create_file = function()
	local extension = vim.fn.input("Enter your file type e.g (.txt, .lua, ...): ")

	if extension == "" then
		print("No extension provided, operation cancelled.")
		return
	end

	local filename = "newfile" .. extension
	vim.cmd("e " .. filename)

	local filetype = vim.fn.fnamemodify(filename, ":e")
	vim.cmd("setlocal filetype=" .. filetype)

	print("Created file: " .. filename .. " with filetype: " .. filetype)
end

-- lualine

M.lsp_progress = function()
	local cur = vim.fn.line(".")
	local total = vim.fn.line("$")
	local spinners = { "", "", "" }

	if cur == 1 then
		return spinners[1]
	elseif cur == total then
		return spinners[3]
	else
		local ms = vim.loop.hrtime() / 1000000
		local frame = math.floor(ms / 120) % #spinners

		return string.format(" %%<%s %s%%%% ", spinners[frame + 1], math.floor(cur / total * 100))
	end
end

M.theme = function()
	-- -- Define the gruvbox color pallete
	-- local colors = {
	-- 	black = "#282828",
	-- 	white = "#ebdbb2",
	-- 	red = "#fb4934",
	-- 	green = "#b8bb26",
	-- 	blue = "#83a598",
	-- 	yellow = "#fe8019",
	-- 	gray = "#a89984",
	-- 	darkgray = "#3c3836",
	-- 	lightgray = "#504945",
	-- 	inactivegray = "#7c6f64",
	-- 	outerbg = "None",
	-- 	innerbg = "None",
	-- }

	-- Define the evil lualine color palette
	local colors = {
		bg = "#202328",
		fg = "#bbc2cf",
	}
	return {
		normal = { c = { fg = colors.fg, bg = colors.bg } },
		inactive = { c = { fg = colors.fg, bg = colors.bg } },
	}
end
-- Icons

local icons = {
	-- AUTO COMPLETION --
	kind = {
		Class = "󰠱",
		Color = "󰏘",
		Constant = "󰏿",
		Constructor = "",
		Enum = "",
		EnumMember = "",
		Event = "",
		Field = "󰇽",
		File = "󰈙",
		Folder = "󰉋",
		Fragment = "",
		Function = "󰊕",
		Interface = "",
		Implementation = "",
		Keyword = "󰌋",
		Method = "󰆧",
		Module = "",
		Namespace = "󰌗",
		Number = "",
		Operator = "󰆕",
		Package = "",
		Property = "󰜢",
		Reference = "",
		Snippet = "",
		Struct = "",
		Text = "󰉿",
		TypeParameter = "󰅲",
		Undefined = "",
		Unit = "",
		Value = "󰎠",
		Variable = "",
		-- ccls-specific icons.
		TypeAlias = "",
		Parameter = "",
		StaticMethod = "",
		Macro = "",
	}, -- -- -- -- -- -- -- -- -- --

	-- Base Icon --

	type = {
		Array = "󰅪",
		Boolean = "",
		Null = "󰟢",
		Number = "",
		Object = "󰅩",
		String = "󰉿",
	},

	git = {
		Add = "",
		Branch = "",
		Diff = "",
		Git = "󰊢",
		Ignore = "",
		Mod = "M",
		Mod_alt = "",
		Remove = "",
		Rename = "",
		Repo = "",
		Unmerged = "󰘬",
		Untracked = "󰞋",
		Unstaged = "",
		Staged = "",
		Conflict = "",
	},

	ui = {
		Accepted = "",
		ArrowClosed = "",
		ArrowOpen = "",
		BigCircle = "",
		BigUnfilledCircle = "",
		BookMark = "󰃃",
		Buffer = "󰓩",
		Bug = "",
		Calendar = "",
		Character = "",
		Check = "󰄳",
		ChevronRight = "",
		Circle = "",
		Close = "󰅖",
		Close_alt = "",
		CloudDownload = "",
		CodeAction = "󰌵",
		Comment = "󰅺",
		Dashboard = "",
		Emoji = "󰱫",
		EmptyFolder = "",
		EmptyFolderOpen = "",
		File = "󰈤",
		Fire = "",
		Folder = "",
		FolderOpen = "",
		FolderWithHeart = "󱃪",
		Gear = "",
		History = "󰄉",
		Incoming = "󰏷",
		Indicator = "",
		Keyboard = "",
		Left = "",
		List = "",
		Square = "",
		SymlinkFolder = "",
		Lock = "󰍁",
		Modified = "✥",
		Modified_alt = "",
		NewFile = "",
		Newspaper = "",
		Note = "󰍨",
		Outgoing = "󰏻",
		Package = "",
		Pencil = "󰏫",
		Perf = "󰅒",
		Play = "",
		Project = "",
		Right = "",
		RootFolderOpened = "",
		Search = "󰍉",
		Separator = "",
		DoubleSeparator = "󰄾",
		SignIn = "",
		SignOut = "",
		Sort = "",
		Spell = "󰓆",
		Symlink = "",
		Tab = "",
		Table = "",
		Telescope = "",
		Window = "",
		Message = "",
	},
	diagnostics = {
		Error = "",
		Warning = "",
		Information = "",
		Question = "",
		Hint = "󰌵",
		-- Holo version
		Error_alt = "󰅚",
		Warning_alt = "󰀪",
		Information_alt = "",
		Question_alt = "",
		Hint_alt = "󰌶",
	},
	misc = {
		Campass = "󰀹",
		Code = "",
		Gavel = "",
		Glass = "󰂖",
		NoActiveLsp = "󱚧",
		PyEnv = "󰢩",
		Squirrel = "",
		Tag = "",
		Tree = "",
		Watch = "",
		Lego = "",
		LspAvailable = "󱜙",
		Vbar = "│",
		Add = "+",
		Added = "",
		Ghost = "󰊠",
		ManUp = "",
		Neovim = "",
		Vim = "",
		Package = "",
		LSP = "",
	},

	tools = {
		Session = "",
		Terminal = "",
		Telescope = "",
		TelescopePrompt = "",
		Selected = "❯",
	},
}

M.gets = function(category, add_space)
	if not vim.g.icons_enabled then
		return ""
	end
	return setmetatable({}, {
		__index = function(_, key)
			return icons[category][key] .. " "
		end,
	})
end

M.capabilities = function()
	require("cmp_nvim_lsp").default_capabilities()
end

M.on_attach = function(client, bufnr)
end
return M
