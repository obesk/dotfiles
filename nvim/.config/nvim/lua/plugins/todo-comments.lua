return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},

	vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { silent = true }),
	vim.keymap.set("n", "<leader>tq", ":TodoLocList<CR>", { silent = true }),

	vim.keymap.set("n", "<leader>t]", function()
		require("todo-comments").jump_next()
	end),

	vim.keymap.set("n", "<leader>t[", function()
		require("todo-comments").jump_prev()
	end),
}
