vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.foldmethod = indent

vim.opt.nu = true --Line numbers
vim.opt.relativenumber = true
vim.opt.signcolumn = "no"
vim.opt.scrolloff = 999 --Do not let cursor scroll below or above N number of lines when scrolling

vim.opt.colorcolumn = "80"
vim.opt.wrap = false
vim.opt.sidescrolloff = 10

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.opt.laststatus = 0
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.cmdheight = 1 --0 to hide completey
vim.opt.showtabline = 0

vim.opt.completeopt = "longest,preview,menuone"
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/tmp/undo"
vim.opt.undofile = true

vim.opt.hlsearch = true --Use highlighting when doing a search
vim.opt.incsearch = true --While searching though a file incrementally highlight matching characters as you type
vim.opt.showmatch = true --Show matching words during a search
vim.opt.ignorecase = true --Ignore capital letters during search
vim.opt.smartcase = true --Override the ignorecase option if searching for capital letters - this will allow you to search specifically for capital letters

vim.opt.updatetime = 500
vim.opt.ttimeoutlen = 10

vim.opt.mouse = ""

vim.g.copilot_model = "gpt-4.1" -- Set the default model for Copilot Chat
