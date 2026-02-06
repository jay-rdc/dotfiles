return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, left, right, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, left, right, opts)
      end

      map("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.nav_hunk("next", { target = "all" })
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Gitsigns: Jump to next hunk" })

      map("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.nav_hunk("prev", { target = "all" })
        end)
        return "<Ignore>"
      end, { expr = true, desc = "Gitsigns: Jump to previous hunk" })

      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns: Stage hunk" })
      map({ "n", "v" }, "<leader>hS", ":Gitsigns stage_buffer<CR>", { desc = "Gitsigns: Stage buffer" })
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns: Reset hunk" })
      map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Gitsigns: Undo stage hunk" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Gitsigns: Preview hunk" })
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { desc = "Gitsigns: Blame line" })

      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns: Select hunk" })
    end,
  },
}
