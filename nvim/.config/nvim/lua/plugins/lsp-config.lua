return {
	"https://github.com/neovim/nvim-lspconfig",
	dependencies = {
		--- lsp servers
		"mason-org/mason.nvim", -- installs packages needed by the LSP
		"mason-org/mason-lspconfig.nvim", -- automatically installs servers needed by the LSP
		-- formatters
		"stevearc/conform.nvim", -- autoformatter
		"zapling/mason-conform.nvim", -- automatically installs formatters needed by conform

		-- autocomplete
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",

		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",

		-- others
		"j-hui/fidget.nvim", -- ui for LSP
	},

	config = function()
		-- LSP SETUP
		-- **** SERVERS USED BY LSP ****
		-- to find other servers use: :help lspconfig-all
		-- or go to this site: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
		local servers = { "lua_ls", "clangd", "rust_analyzer", "pyright", "html", "gopls" }

		-- this needs to be before the lsp-config configuration
		require("mason").setup({})
		-- ensuring that Mason installs the servers
		require("mason-lspconfig").setup({
			ensure_installed = servers,
		})

		-- enabling the servers
		for _, lsp in ipairs(servers) do
			vim.lsp.enable(lsp)
		end

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "it", "describe", "before_each", "after_each" },
					},
				},
			},
		})

		-- AUTOFORMATTER SETUP
		-- to see other formatters :help conform-formatters
		-- or at this url: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				rust = { "rustfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				yaml = { "yamlfmt" },
				xml = { "xmlformatter" },
				json = { "fixjson" },
				html = { "html_beautify" },
				go = { "gofmt" },
			},

			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})

		-- this needs to be after the conform configuration
		require("mason-conform").setup({
			ignore_install = { "rustfmt" }, -- installation of rustfmt via mason is depracated, use rustup
		})

		require("fidget").setup({})

		-- AUTOCOMPLETE SETUP
		local luasnip = require("luasnip")
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if luasnip.expandable() then
							luasnip.expand()
						else
							cmp.confirm({
								select = true,
							})
						end
					else
						fallback()
					end
				end),

				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.locally_jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
			preselect = cmp.PreselectMode.None,
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("*", { capabilities = capabilities })

		-- disabled because of conflict with lsp c-k
		-- vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})

		-- move to the next autocompleted function argument
		vim.keymap.set({ "i", "s" }, "<C-L>", function()
			luasnip.jump(1)
		end, { silent = true })
		-- move to the prev autocompleted function argument
		vim.keymap.set({ "i", "s" }, "<C-H>", function()
			luasnip.jump(-1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-E>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, { silent = true })

		require("luasnip.loaders.from_vscode").lazy_load()
		-- TODO: implement own snippets, see friendly snippets as example
		-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./my-cool-snippets" } })

		-- ****** keybindings for the LSP
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function()
				local bufmap = function(mode, lhs, rhs)
					local opts = { buffer = true }
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				-- Displays hover information about the symbol under the cursor
				bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
				-- Jump to the definition
				bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
				-- Jump to declaration
				bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
				-- Lists all the implementations for the symbol under the cursor
				bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
				-- Jumps to the definition of the type symbol
				bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
				-- Lists all the references
				bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
				-- Displays a function's signature information
				bufmap({ "n", "i" }, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
				-- Renames all references to the symbol under the cursor
				bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")
				-- Selects a code action available at the current cursor position
				bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
				bufmap("x", "<F4>", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")

				-- Show diagnostics in a floating window
				bufmap("n", "<leader>ds", "<cmd>lua vim.diagnostic.open_float()<cr>")
				-- Move to the previous diagnostic
				bufmap("n", "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
				-- Move to the next diagnostic
				bufmap("n", "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<cr>")

				bufmap("n", "<leader>li", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>")
				bufmap("n", "<leader>lo", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>")
			end,
		})
	end,
}
