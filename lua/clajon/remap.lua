require("clajon.functions")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>p", vim.cmd.Ex)
vim.keymap.set("n", "<C-s>", vim.cmd.wa)
vim.keymap.set("n", "<leader>g", vim.cmd.Git)
vim.keymap.set("n", "<leader>j", vim.cmd.bn)
vim.keymap.set("n", "<leader>k", vim.cmd.bp)


--plugins
vim.keymap.set("n", "<leader>cf", function() vim.cmd("HandleFiletype") end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", ":CopilotChat", { noremap = true, silent = true })
