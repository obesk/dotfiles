local cmp = require 'cmp'

-- setting up the autocompletion
cmp.setup({
	snippet = {
		expand = function(args) require('luasnip').lsp_expand(args.body) end, -- adding the luasnip as the snippet engine
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'luasnip' },
		{ name = 'nvim_lua' },
	})
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done()) -- adding autopairs support

-- autocompletion capabilities to add to language servers
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>es', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>en', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>ep', vim.diagnostic.goto_prev, opts)

local my_attach = function(client, bufnr)
	require("lsp-format").on_attach(client)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	-- vim.keymap.set('n', 'gde', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'gs', ":ClangdSwitchSourceHeader<CR>", bufopts)
	vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	-- vim.keymap.set('n', 'gdt', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
end


-- setting up mason
require('mason').setup()
require('mason-lspconfig').setup { automatic_installation = true }

local lspconfig = require('lspconfig')
-- go to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md to find new servers
local servers = { 'rust_analyzer', 'gopls', 'pyright', 'tsserver', 'clangd', 'hls', 'html', 'htmx' }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = my_attach,
		capabilities = capabilities,
	}
end

-- specific lsp config for lua_ls
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT', },
			diagnostics = { globals = { 'vim' }, },
			workspace = {
				library = {
					vim.api.nvim_get_runtime_file("", true),
				}
			},
			telemetry = { enable = false, },
		},
	},
	on_attach = my_attach,
	capabilities = capabilities,
}
