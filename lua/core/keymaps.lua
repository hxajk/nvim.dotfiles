-- Key maps ---------------------------------------------

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
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- Visual mode mappings
vim.keymap.set("x", "X", '"_x"', { desc = "Delete all characters in line" })
vim.keymap.set("x", ">", "<gv", { desc = "Indent line" })
vim.keymap.set("x", "<", "<gv", { desc = "Unindent line" })

-- Terminal mode mappings

vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Terminal left window navigation" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Terminal down window navigation" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Terminal up window navigation" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Terminal right window navigation" })

