local cmp = require 'cmp'

cmp.setup({
	snippet = {
		expand = function(args) require('luasnip').lsp_expand(args.body) end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		cocumentation = cmp.config.window.bordered(),
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
	}, {
		{ name = 'buffer' },
	})
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on(
'confirm_done',
cmp_autopairs.on_confirm_done()
)

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>es', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>en', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>ep', vim.diagnostic.goto_prev, opts)

local my_attach = function(client, bufnr)
	require("lsp-format").on_attach(client)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'gs', ":ClangdSwitchSourceHeader<CR>", bufopts)
	vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
end

-- go to https://github.com/neovim/nvim-lspconfig to find new servers
local lspconfig = require('lspconfig')
local servers = { 'rust_analyzer', 'pyright', 'tsserver', 'clangd', 'hls' }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = my_attach,
		capabilities = capabilities,
	}
end

require('lspconfig').lua_ls.setup {
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
