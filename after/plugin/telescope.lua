local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
-- vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>ph", builtin.help_tags, {})
vim.keymap.set("n", "<leader>pt", builtin.tags, {})
vim.keymap.set("n", "<leader>ps", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>pj", builtin.jumplist, {})
vim.keymap.set("n", "<leader>pm", builtin.marks, {})
vim.keymap.set("n", "<leader>pr", builtin.registers, {})
vim.keymap.set("n", "<leader>pq", builtin.quickfix, {})
vim.keymap.set("n", "<leader>pqh", builtin.quickfixhistory, {})

--Git
vim.keymap.set("n", "<leader>pp", builtin.git_files, {})
vim.keymap.set("n", "<leader>ppc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>pps", builtin.git_stash, {})
vim.keymap.set("n", "<leader>ppb", builtin.git_branches, {})
vim.keymap.set("n", "<leader>ppbc", builtin.git_bcommits, {})

-- Copilot chat
vim.keymap.set("n", "<leader>pc", function()
	local actions = require("CopilotChat.actions")
	require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { desc = "CopilotChat - Prompt actions" })

-- Telescope buffers with delete buffer action
vim.keymap.set("n", "<leader>pb", function()
	require("telescope.builtin").buffers({
		attach_mappings = function(_, map)
			local actions = require("telescope.actions")
			map("i", "<C-d>", actions.delete_buffer)
			map("n", "<C-d>", actions.delete_buffer)
			return true
		end,
	})
end, {})
