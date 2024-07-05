-- Coding Tools plugins

local icons = {
	kind = require("core").gets("kind"),
	diagnostics = require("core").gets("diagnostics"),
	misc = require("core").gets("misc"),
	ui = require("core").gets("ui"),
}

local default = {

	-- nvim-treesitter/nvim-treesitter -> [Nvim Treesitter configurations and abstraction layer]
	-- https://github.com/nvim-treesitter/nvim-treesitter

	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufRead", "BufNewFile" },
		build = function()
			if #vim.api.nvim_list_uis() ~= 0 then
				vim.api.nvim_command([[TSUpdate]])
			end
		end,
		lazy = vim.fn.argc(-1) == 0,
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			auto_install = vim.fn.executable("git") == 1 and vim.fn.executable("tree-sitter") == 1,
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

	-- neovim/nvim-lspconfig -> [Quickstart configs for Nvim LSP]
	-- https://github.com/neovim/nvim-lspconfig

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
					capabilities = require("core").capabilities(),
				})
			end

			require("lspconfig").lua_ls.setup({
				capabilities = require("core").capabilities(),

				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			vim.fn.sign_define(
				"DiagnosticSignError",
				{ text = icons.diagnostics.Error, texthl = "DiagnosticSignError" }
			)
			vim.fn.sign_define(
				"DiagnosticSignWarn",
				{ text = icons.diagnostics.Warning, texthl = "DiagnosticSignWarn" }
			)
			vim.fn.sign_define(
				"DiagnosticSignInfo",
				{ text = icons.diagnostics.Information, texthl = "DiagnosticSignInfo" }
			)
			vim.fn.sign_define("DiagnosticSignHint", { text = icons.diagnostics.Hint, texthl = "DiagnosticSignHint" })
			vim.api.nvim_command([[LspStart]])

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local function options(desc)
						return { desc = desc, buffer = ev.buf }
					end

					vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, options("LSP: Show signature help"))

					vim.keymap.set("n", "ld", vim.lsp.buf.definition, options("LSP: Show definition"))

					vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", options("LSP: Info"))

					vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, options("LSP: Hover file"))

					vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, options("LSP: Rename Varable"))

					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, options("LSP: Previous Diagnostic"))

					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, options("LSP: Next Diagnostic"))

					vim.keymap.set(
						{ "n", "v" },
						"<leader>lf",
						require("conform").format({ bufnr = ev.buf }),
						{ desc = "LSP: Format file", buffer = ev.buf }
					)

					vim.keymap.set("n", "<leader>lu", function()
						vim.g.autoformat = not vim.g.autoformat

						if vim.g.autoformat then
							vim.notify("Enable Auto Format")
						else
							vim.notify("Disable Auto Format")
						end
					end, { desc = "LSP: Toggle autoformat" })

					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = "*",
						callback = function(args)
							if vim.g.autoformat then
								require("conform").format({ bufnr = args.buf })
							end
						end,
					})
				end,
			})
		end,
	},

	-- stevearc/conform.nvim -> [Lightweight yet powerful formatter plugin for Neovim]
	-- https://github.com/stevearc/conform.nvim

	{
		"stevearc/conform.nvim",
		lazy = true,
		cmd = "ConformInfo",
		event = { "CursorHold", "CursorHoldI" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
			vim.keymap.set({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, { desc = "LSP: Format file" })

			vim.keymap.set("n", "<leader>lu", function()
				vim.g.autoformat = not vim.g.autoformat

				if vim.g.autoformat then
					vim.notify("Enable Auto Format")
				else
					vim.notify("Disable Auto Format")
				end
			end, { desc = "LSP: Toggle autoformat" })

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

	-- hrsh7th/nvim-cmp -> [A completion plugin for neovim coded in Lua]
	-- https://github.com/hrsh7th/nvim-cmp

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },

			{ "L3MON4D3/LuaSnip", version = "v2.*", lazy = true },
		},
		lazy = true,
		event = "InsertEnter",
		version = false,
		opts = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			local compare = require("cmp.config.compare")
			return {
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				preselect = cmp.PreselectMode.None,

				-- window = {
				--
				-- },

				experimental = {
					ghost_text = {
						hl_group = "Whitespace",
					},
				},

				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(_, item)
						-- Kind icons
						if icons.kind[item.kind] then
							item.kind = icons.kind[item.kind] .. " " .. item.kind
						end

						return item
					end,
				},

				sorting = {
					priority_weight = 2,
					comparators = {
						compare.offset,
						compare.exact,
						compare.score,
						compare.recently_used,
						compare.kind,
					},
				},

				matching = {
					disallow_partial_fuzzy_matching = false,
				},
				performance = {
					async_budget = 1,
					max_view_entries = 120,
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
			require("cmp").setup(opts)

			-- From cmp wiki (https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance)
			-- gray
			vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
			-- blue
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
			-- light blue
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })
			vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
			vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
			-- pink
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
			vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
			-- front
			vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })
			vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
			vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
		end,
	},

	-- williamboman/mason.nvim -> [Easily install and manage LSP servers, DAP servers, linters, and formatters]
	-- https://github.com/williamboman/mason.nvim

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		build = ":MasonUpdate",
		lazy = true,
		opts = {
			ui = {
				border = "single",
				icons = {
					package_pending = icons.ui.Modified_alt,
					package_installed = icons.ui.Check,
					package_uninstalled = icons.misc.Ghost,
				},
				keymaps = {
					toggle_server_expand = "<CR>",
					install_server = "i",
					update_server = "u",
					check_server_version = "c",
					update_all_servers = "U",
					check_outdated_servers = "C",
					uninstall_server = "X",
					cancel_installation = "<C-c>",
				},
			},
			log_level = vim.log.levels.INFO,
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
