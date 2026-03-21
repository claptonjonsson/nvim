require("clajon.functions.onsave")

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--vim.keymap.set("n", "<C-s>", vim.cmd.wa)
vim.keymap.set("n", "<leader>p", vim.cmd.Ex) -- File browser
vim.keymap.set("n", "H", ":noh<CR>", { noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true }) --Esc exits terminal mode

vim.keymap.set("n", "<leader>g", vim.cmd.Git) -- Git

--Browse buffers forward and backward
vim.keymap.set("n", "<leader>k", vim.cmd.bn)
vim.keymap.set("n", "<leader>j", vim.cmd.bp)

-- Fuction to be called when saving, depending on filetype.
vim.keymap.set("n", "<C-s>", function()
	vim.cmd("OnSave")
end, { noremap = true, silent = true })

--PLUGINS

--Copilot
vim.keymap.set({ "n", "v" }, "<leader>c<leader>", ":CopilotChat ", { noremap = true, silent = true }) -- Copilot chat
vim.keymap.set("n", "<leader>ce", "<cmd>Copilot enable<CR>", { noremap = true, silent = true }) -- Copilot inline suggestion enable
vim.keymap.set("n", "<leader>cd", "<cmd>Copilot disable<CR>", { noremap = true, silent = true }) -- Copilot inline suggestion disable
vim.keymap.set("n", "<leader>cp", function() -- Copilot panel (opens and focuses it)
	vim.cmd("Copilot panel")
	vim.schedule(function()
		local panel = require("copilot.panel")
		if panel.winid and vim.api.nvim_win_is_valid(panel.winid) then
			vim.api.nvim_set_current_win(panel.winid)
		end
	end)
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ct", "<cmd>Copilot suggestion toggle_auto_trigger<CR>", { noremap = true, silent = true }) -- Copilot auto trigger toggle
