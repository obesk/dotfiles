return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		-- to see available modules https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "cpp", "lua", "rust", "vim", "vimdoc", "query", "markdown_inline", go },
			highlight = {
				enable = true,
			},
		})
	end,
}
