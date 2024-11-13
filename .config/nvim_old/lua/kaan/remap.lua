vim.g.mapleader = " "

-- Easier Esc
-- vim.keymap.set({"i", "v"}, "jk", "<Esc>")
-- vim.keymap.set({"i", "v"}, "kj", "<Esc>")
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Easier window switch
vim.keymap.set("n", "<leader>w", "<C-w>")

-- Move highlighted lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Project view
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- J inserts line below cursor to current line with a space in between
-- This remap fixes cursor position while doing this
vim.keymap.set("n", "J", "mzJ`z")

-- Center screen after half pages
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor at center when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over without overriding register
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Delete to void register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("v", "x", "\"_x")

-- Rename in whole file
vim.keymap.set("n", "<leader>s",
	":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
