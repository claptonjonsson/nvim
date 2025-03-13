return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	-- or                              , branch = '0.1.x',
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },

	-- To get fzf loaded and working with telescope, you need to call
	-- load_extension, somewhere after setup function:
	-- require('telescope').load_extension('fzf')
}
