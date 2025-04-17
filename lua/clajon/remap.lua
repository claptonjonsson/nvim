require("clajon.functions.onsave")

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--vim.keymap.set("n", "<C-s>", vim.cmd.wa)
vim.keymap.set("n", "<leader>p", vim.cmd.Ex) -- File browser
vim.keymap.set("n", "H", ":noh<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>g", vim.cmd.Git) -- Telescope Git

--Browse buffers forward and backward
vim.keymap.set("n", "<leader>j", vim.cmd.bn)
vim.keymap.set("n", "<leader>k", vim.cmd.bp)

-- Fuction to be called when saving, depending on filetype.
vim.keymap.set("n", "<C-s>", function()
	vim.cmd("OnSave")
end, { noremap = true, silent = true })

--PLUGINS

--Copilot
vim.keymap.set({ "n", "v" }, "<leader>c", ":CopilotChat ", { noremap = true, silent = true }) -- Copilot chat
vim.keymap.set("i", "<S-Tab>", "<Plug>(copilot-accept-word)", { silent = true }) -- Map Ctrl-Tab to accept word
vim.keymap.set("i", "<A-Tab>", "<Plug>(copilot-accept-line)", { silent = true }) -- Map Shift-Tab to accept line
