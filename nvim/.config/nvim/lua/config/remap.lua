vim.g.mapleader = " "

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below without moving cursor" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go down half a page then center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go up half a page then center cursor" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Go to next word match then center cursor" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Go to previous word match then center cursor" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted text down one line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted text up one line" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent highlighted text right then reselect" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent highlighted text left then reselect" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste yanked text without yanking replaced text" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank text to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete text without yanking deleted text" })

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Go to next quickfix list item" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Go to previous quickfix list item" })

vim.keymap.set("n", "[b", vim.cmd.bprev, { desc = "Switch to previous buffer" })
vim.keymap.set("n", "]b", vim.cmd.bnext, { desc = "Switch to next buffer" })

vim.keymap.set("v", "<leader>ga", ":diffget", { desc = "Diff: Wait for buffer input then accept" })
vim.keymap.set(
  "v",
  "<leader>gA",
  [[:g/^<\{7}\|^=\{7}\|^>\{7}/d<CR>]],
  { desc = "Git merge conflict: Accept both changes" }
)

vim.keymap.set(
  "n",
  "<leader>bd",
  "<cmd>%bd<CR><C-o><cmd>bd#<CR>",
  { desc = "Delete all buffers excluding the current buffer" }
)

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-z>", "<nop>")
