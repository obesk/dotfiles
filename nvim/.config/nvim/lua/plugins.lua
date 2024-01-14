-- ensures that packer is installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(
	function(use)
		use 'wbthomason/packer.nvim'

		-- these should already be nvim features
		use { 'ThePrimeagen/harpoon' }
		use { 'terrortylor/nvim-comment', run = function() require('nvim_comment').setup() {} end }
		use { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup {} end }

		-- expanding the vim keybingins
		use { 'wellle/targets.vim' }
		use { 'kylechui/nvim-surround' }
		use { 'michaeljsmith/vim-indent-object' }

		--------- vim like an ide --------------
		use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- chad dialog
		use { "nvim-telescope/telescope-file-browser.nvim" }
		use { "stevearc/oil.nvim", requires = 'ryanoasis/vim-devicons' }          -- file management
		-- use { "startup-nvim/startup.nvim" }

		-- LSP support
		use { 'williamboman/mason.nvim' }                                                             -- package manager for language servers
		use { 'williamboman/mason-lspconfig.nvim' }                                                   -- mason config for the lsp
		use { 'neovim/nvim-lspconfig' }                                                               -- lsp configurations
		use { 'nvim-treesitter/nvim-treesitter' }                                                     -- plugin to easy access to tree-sitter
		use { 'nvim-treesitter/nvim-treesitter-context', requires = { 'nvim-treesitter/nvim-treesitter' } } --function name on top
		use { 'lukas-reineke/lsp-format.nvim' }                                                       -- lsp autoformatting

		-- autocompletion
		use { 'hrsh7th/nvim-cmp' }   -- autocompletion
		use { 'hrsh7th/cmp-nvim-lsp' } -- LSP source for autocompletion
		use { 'hrsh7th/cmp-buffer' } -- buffer words source for autocompletion
		use { 'hrsh7th/cmp-path' }   -- filesystem paths source for autocompletion
		use { 'saadparwaiz1/cmp_luasnip' } -- snippets source for nvim-cmp
		use { 'hrsh7th/cmp-nvim-lua' } -- nvim-lua source for autocompletion

		-- snippets
		-- TODO: add with friendly-snippets?
		use { 'L3MON4D3/LuaSnip' } -- Snippets plugin
		------------------------------------------

		-- git integrations
		use { "tpope/vim-fugitive" } -- git for chads
		use { "lewis6991/gitsigns.nvim" }

		-- general utils
		use { 'christoomey/vim-tmux-navigator' } -- tmux navigation integration
		use { "mbbill/undotree" }          -- creates a nice undo tree



		-- aspect
		use { 'nvim-lualine/lualine.nvim' }
		use { 'ryanoasis/vim-devicons' }
		use { "lukas-reineke/indent-blankline.nvim" }
		use { "catppuccin/nvim", as = "catppuccin" }
		if packer_bootstrap then
			require('packer').sync()
		end
	end
)
