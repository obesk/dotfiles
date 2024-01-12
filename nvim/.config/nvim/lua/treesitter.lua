require 'nvim-treesitter.configs'.setup {
	-- here you can find other languages https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"javascript",
		"css",
		"html",
		"bash",
		"cpp",
		"rust",
		"cmake",
		"make",
		"csv",
		"dockerfile",
		"yaml",
		"haskell",
		"json",
		"json5",
		"markdown",
		"meson",
		"ninja",
		"python",
		"regex",
		"sql",
		"ssh_config",
	},
	sync_install = false,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

require 'treesitter-context'.setup()

