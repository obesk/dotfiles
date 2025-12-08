return {
	"stevearc/oil.nvim",
	dependencies = { "ryanoasis/vim-devicons" },
	config = function()
		require("oil").setup({
			columns = {
				{ "icon", default_file = "", directory = "" },
				"size",
			},
			keymaps = {
				["<C-p>"] = false,
				["gp"] = "actions.preview",
			},
			view_options = {
				show_hidden = true,
			},
			skip_confirm_for_simple_edits = true,
		})
		vim.keymap.set({ "n", "i" }, "<C-n>", ":Oil<CR>")
	end,
}
