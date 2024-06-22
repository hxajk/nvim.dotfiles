-- Mappings general

local icons = {
    misc = require("core").gets("misc"),
}


-- Insert mode mappings
vim.keymap.set("i", "jj", "<ESC>", { desc = "Turn to normal mode" })
vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })

-- Normal mode mappings
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize up" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize down" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })
vim.keymap.set("n", "<S-Down>", function()
    vim.api.nvim_feedkeys("5j", "n", true)
end, { desc = "Fast move down" })
vim.keymap.set("n", "<S-Up>", function()
    vim.api.nvim_feedkeys("5k", "n", true)
end, { desc = "Fast move up" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- Visual mode mappings
vim.keymap.set("x", "X", '"_x"', { desc = "Delete all characters in line" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent line" })
vim.keymap.set("x", "<", "<gv", { desc = "Unindent line" })

-- Terminal mode mappings
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Terminal left window navigation" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Terminal down window navigation" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Terminal up window navigation" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Terminal right window navigation" })

-- Lazy package mananger mappings

vim.keymap.set("n", "<leader>p", "<cmd> <leader>p <cr>", { desc = icons.misc.Package .. "Package" })
vim.keymap.set("n", "<leader>ps", "<cmd> Lazy <cr>", { desc = "Package: Show" })
vim.keymap.set("n", "<leader>pu", "<cmd> Lazy sync <cr>", { desc = "Package: Sync" })
vim.keymap.set("n", "<leader>pi", "<cmd> Lazy update <cr>", { desc = "Package: Update" })
vim.keymap.set("n", "<leader>pl", "<cmd> Lazy install <cr>", { desc = "Package: Install" })
vim.keymap.set("n", "<leader>pc", "<cmd> Lazy log <cr>", { desc = "Package: Log" })
vim.keymap.set("n", "<leader>pd", "<cmd> Lazy check <cr>", { desc = "Package: Check" })
vim.keymap.set("n", "<leader>pp", "<cmd> Lazy debug <cr>", { desc = "Package: Debug" })
vim.keymap.set("n", "<leader>pr", "<cmd> Lazy Restore <cr>", { desc = "Package: Restore" })
vim.keymap.set("n", "<leader>px", "<cmd> Lazy clean <cr>", { desc = "Package: Clean" })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local function map(mode, key, core, desc)
            vim.keymap.set(mode, key, core, { desc = desc, buffer = ev.buf })
        end

        -- Using the custom map function

        map("n", "<leader>l", "<leader>l", icons.misc.LSP .. "LSP")

        map("n", "<leader>lh", vim.lsp.buf.signature_help, "Show signature help")

        map('n', 'ld', vim.lsp.buf.definition, "Show definition")

        map("n", "<leader>li", "<cmd>LspInfo<cr>", "Lsp Info")

        map("n", "<leader>lk", vim.lsp.buf.hover, "Hover")

        map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")

        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

        map("n", "<leader>ln", vim.lsp.buf.rename, "Rename Varable")
    end,
})

require("custom.keymaps")
