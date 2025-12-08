return {
	"https://github.com/lewis6991/gitsigns.nvim.git",

	config = function()
		require("gitsigns").setup({})
		vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<CR>", { silent = true })
		-- this magical command closes the window created by diff_this
		vim.keymap.set("n", "<leader>gc", ":wincmd p | q<CR>", { silent = true })

		vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { silent = true })
		vim.keymap.set("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { silent = true })
		vim.keymap.set("n", "<leader>g[", ":Gitsigns prev_hunk<CR>", { silent = true })
		vim.keymap.set("n", "<leader>g]", ":Gitsigns next_hunk<CR>", { silent = true })
		vim.keymap.set("n", "<leader>gq", ":Gitsigns setqflist", { silent = true })
	end,
}
