-- ensures that packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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

		-- big brain movement / selection
		-- use { 'wellle/targets.vim' }
		use { 'kylechui/nvim-surround' }
		use { 'michaeljsmith/vim-indent-object' }

		-- vim like an ide
		use { 'neovim/nvim-lspconfig' } --linting
		use { 'nvim-treesitter/nvim-treesitter' } --highlight
		use { 'nvim-treesitter/nvim-treesitter-context', requires = { 'nvim-treesitter/nvim-treesitter' } } --function name on top
		use { 'hrsh7th/nvim-cmp' } --autocompletion
		use { 'saadparwaiz1/cmp_luasnip' } -- Snippets source for nvim-cmp
		use { 'L3MON4D3/LuaSnip' } -- Snippets plugin
		use { 'hrsh7th/cmp-nvim-lsp' } -- LSP source for nvim-cmpauto
		use { 'lukas-reineke/lsp-format.nvim' } -- autoformatting
		use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } } --fuzzy finder

		-- general utils
		use { 'christoomey/vim-tmux-navigator' } -- tmux navigation integration

		-- aspect
		use { 'nvim-lualine/lualine.nvim' }
		use { "nvim-tree/nvim-tree.lua" } 
		use { 'ryanoasis/vim-devicons' }
		-- themes
		use { "catppuccin/nvim", as = "catppuccin" }

		  if packer_bootstrap then
		    require('packer').sync()
		  end
	end
)
