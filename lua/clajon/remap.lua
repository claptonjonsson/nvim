require("clajon.functions")

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--vim.keymap.set("n", "<C-s>", vim.cmd.wa)
vim.keymap.set("n", "<leader>p", vim.cmd.Ex) -- File browser
vim.keymap.set('n', 'H', ':noh<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>g", vim.cmd.Git) -- Telescope Git

--Browse buffers forward and backward
vim.keymap.set("n", "<leader>j", vim.cmd.bn)
vim.keymap.set("n", "<leader>k", vim.cmd.bp)

-- Fuction to be called when saving, depending on filetype.
vim.keymap.set("n", "<C-s>", function()
	vim.cmd("OnSave")
end, { noremap = true, silent = true })

--plugins
vim.keymap.set("n", "<leader>c", ":CopilotChat", { noremap = true, silent = true })
