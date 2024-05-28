-------------------- Development Tools ----------------------------

local get_icons = require("core").get_icon
local default = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			if #vim.api.nvim_list_uis() ~= 0 then
				vim.api.nvim_command([[TSUpdate]])
			end
		end,
		event = "BufReadPre",
		lazy = true,
		version = false,
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		opts = {
			hightlight = {
				enable = true,
				disable = { "help" },
			},
			indent = { enable = true },

			ensure_installed = {
				"markdown",
				"vim",
				"lua",
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		-- LSP and Autocompletion
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		opts = function()
			return {
				underline = true,
				severity_sort = true,
				update_in_insert = false,
				diagnostic = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
					},
					severity_sort = true,
				},
			}
		end,
		config = function(_, opts)
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = { "clangd", "pyright" }

			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup({
					on_attach = function(client, buffer)
						require("core").on_attach(client, buffer)
					end,

					capabilities = require("core").capabilities(),
				})
			end

			require("lspconfig").lua_ls.setup({
				on_attach = function(client, buffer) end,

				capabilities = require("cmp_nvim_lsp").default_capabilities(),

				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
			vim.keymap.set("n", "<leader>l", "<leader>l", { desc = "+" .. get_icons("LSP", 1, true) .. "LSP" })
			vim.keymap.set("n", "<leader>lu", function()
				vim.g.autoformat = not vim.g.autoformat

				if vim.g.autoformat then
					vim.notify("Enable Auto Format")
				else
					vim.notify("Disable Auto Format")
				end
			end, { desc = "Toggle autoformat" })

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					if vim.g.autoformat then
						require("conform").format({ bufnr = args.buf })
					end
				end,
			})
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		event = "VeryLazy",
		lazy = true,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		lazy = true,
		event = "InsertEnter",
		version = false,
		opts = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local icons = require("core").Icons

			return {
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},

				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(_, item)
						-- Kind icons
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end

						return item
					end,
				},
				mapping = {
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			}
		end,

		config = function(_, opts)
			local cmp = require("cmp")

			cmp.setup(opts)
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		build = ":MasonUpdate",
		lazy = true,
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_uninstalled = "✗",
					package_pending = "⟳",
				},
			},
		},
		keys = {
			{ "<leader>p", "<Cmd><leader>p<CR>", desc = "+" .. get_icons("Package", 1, true) .. "Packages" },
			{ "<leader>pm", "<Cmd>Mason<CR>", desc = "Open Language Menu" },
			{ "<leader>pu", "<Cmd>MasonUpdate<CR>", desc = "Refesh Language" },
		},
		config = function(_, opts)
			local ensure_installed = { "lua-language-server", "stylua" }

			local mr = require("mason-registry")

			require("mason").setup(opts)

			local function installer()
				for _, tool in ipairs(ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end

			if mr.refresh then
				mr.refresh(installer)
			else
				installer()
			end
		end,
	},
}

return default
