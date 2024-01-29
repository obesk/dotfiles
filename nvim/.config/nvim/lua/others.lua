require('gitsigns').setup()
require("nvim-surround").setup()
require('nvim_comment').setup()
require("ibl").setup() -- setting up indentation guides
require("oil").setup {
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
	}
}


vim.keymap.set({ 'n', 'i' }, '<C-n>', ':Oil<CR>')
vim.keymap.set('n', '<leader>n', ':UndotreeToggle<CR>')

-- require("startup").setup({ theme = "dashboard" }) -- put theme name here
-- require('leap').add_default_mappings()
