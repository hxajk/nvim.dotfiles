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
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
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


M.capabilities = function ()
    require('cmp_nvim_lsp').default_capabilities()
end

M.on_attach = function(client, _)
    
    vim.keymap.set("n","<leader>lh",
    function()
        return vim.lsp.buf.signature_help
    end,
    {desc = "Show signature help"}
    )
    
    vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", {desc = "Lsp Info"})
    
    vim.keymap.set("n", "<leader>lk", 
    function()
        return vim.lsp.buf.hover 
    end, 
    {desc = "Hover"}
    )

    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {desc = "Code Action"})

    vim.keymap.set("n", "<leader>lc", vim.lsp.codelens.run, {desc = "Run Codelens"})

    vim.keymap.set("n", "<leader>lC", vim.lsp.codelens.refresh, {desc = "Refresh & Display Codelens"})
    
    	if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>lf", 
            function() 
                return vim.lsp.buf.format() 
            end, 
        {"Format buffer"}
    )
	end
end

return M
