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

-- Icons

M.Icons = {
	-- AUTO COMPLETION --
	kinds = {
		Array = " ",
		Boolean = "󰨙 ",
		Class = " ",
		Codeium = "󰘦 ",
		Color = " ",
		Control = " ",
		Collapsed = " ",
		Constant = "󰏿 ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = "󰊕 ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = "󰊕 ",
		Module = " ",
		Namespace = "󰦮 ",
		Null = " ",
		Number = "󰎠 ",
		Object = " ",
		Operator = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = "󰆼 ",
		TabNine = "󰏚 ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = "󰀫 ",
	},
	-- -- -- -- -- -- -- -- -- --

	-- Base Icon --
	base = {
		DiagnosticError = "",
		DiagnosticHint = "󰌵",
		DiagnosticInfo = "󰋼",
		DiagnosticWarn = "",
		Git = "󰊢",
		GitAdd = "▎",
		GitChange = "▎",
		GitDelete = "",
		GitTopDelete = "",
		GitChangeDelete = "▎",
		GitUnTracked = "▎",
		Session = "",
		Tab = "󰓩",
		Buffer = "󰓩", --Buffer == Tab, aight?
		Terminal = "",
		Message = "",
		TelescopePrompt = "",
		Flash = "⚡",
		Clock = "",
		Telescope = "", -- The same, but i want so...
		LSP = "",
		Package = "",
	},

	-- -- -- -- -- -- --
}

M.get_icon = function(kind, padding, enable) -- Later on...
	if not vim.g.icons_enabled and enable then
		return ""
	end

	local Base = M.Icons
	local icon = Base["base"] and Base["base"][kind]
	return icon and icon .. string.rep(" ", padding or 0) or ""
end

M.capabilities = function()
	require("cmp_nvim_lsp").default_capabilities()
end

M.on_attach = function(client, bufnr)
	local function map(mode, key, core, desc)
		vim.keymap.set(mode, key, core, { desc = desc, buffer = bufnr })
	end

	-- Using the custom map function

    map("n", "<leader>l", "<leader>l", "+" .. M.get_icon("LSP", 1, true) .. "LSP" )

	map("n", "<leader>lh", vim.lsp.buf.signature_help, "Show signature help")

	map("n", "<leader>li", "<cmd>LspInfo<cr>", "Lsp Info")

	map("n", "<leader>lk", vim.lsp.buf.hover, "Hover")

    map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")

    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Varable")

	if client.supports_method("textDocument/formatting") then

		map({ "n", "v" }, "<leader>lf", vim.lsp.buf.format,"Format buffer")

	end
end
return M
