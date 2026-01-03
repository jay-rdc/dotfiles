return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Fugitive: Git status" })
    vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit!<CR>", { desc = "Fugitive: Git diff/merge tool" })
    vim.keymap.set("n", "<leader>gl", "<cmd>G log %<CR>", { desc = "Fugitive: Git log of current file" })
    vim.keymap.set("n", "<leader>gL", "<cmd>G log<CR>", { desc = "Fugitive: Git log of repo" })
  end
}
