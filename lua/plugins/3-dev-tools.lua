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
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "CursorHold", "CursorHoldI" },
        config = function(_, _)
            local lsp_status_ok, lspconfig = pcall(require, 'lspconfig')
            if not lsp_status_ok then
                return
            end

            local cmp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
            if not cmp_status_ok then
                return
            end


            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)


            local on_attach = function(client, bufnr)
                if client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
                    vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
                    vim.api.nvim_create_autocmd("CursorHold", {
                        callback = vim.lsp.buf.document_highlight,
                        buffer = bufnr,
                        group = "lsp_document_highlight",
                        desc = "Document Highlight",
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        callback = vim.lsp.buf.clear_references,
                        buffer = bufnr,
                        group = "lsp_document_highlight",
                        desc = "Clear All the References",
                    })
                end

                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

                local function options(desc)
                    return { desc = desc, buffer = bufnr.buf }
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
                    require("conform").format({ bufnr = bufnr }),
                    { desc = "LSP: Format file", buffer = bufnr }
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
            end

            vim.diagnostic.config({
                update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })

            local servers = { 'lua_ls', 'pyright', 'clangd' }

            -- Call setup
            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup {
                    on_attach = on_attach,
                    root_dir = function() return vim.fn.getcwd() end,
                    capabilities = capabilities,
                    flags = {
                        -- default in neovim 0.7+
                        debounce_text_changes = 150,
                    }
                }
            end

            lspconfig["lua_ls"].setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            vim.api.nvim_command([[LspStart]])
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
        end,
    },

    -- hrsh7th/nvim-cmp -> [A completion plugin for neovim coded in Lua]
    -- https://github.com/hrsh7th/nvim-cmp

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },

            { "L3MON4D3/LuaSnip",    version = "v2.*", lazy = true },
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
