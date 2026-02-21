return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")

    local show_previewer = { layout = { preview = true } }

    snacks.setup({
      picker = {
        ui_select = true,
        layout = {
          preview = false,
        },
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              min_width = 120,
              width = 0.8,
              height = 0.8,
              {
                box = "vertical",
                border = true,
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              {
                win = "preview",
                title = "{preview}",
                border = true,
                width = 0.6,
                wo = { signcolumn = "no", number = false },
              },
            },
          },
          select = {
            layout = {
              relative = "cursor",
              row = 1,
            },
          },
        },
        sources = {
          grep = show_previewer,
          grep_word = show_previewer,
          lsp_references = show_previewer,
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<A-h>"] = { "preview_scroll_left", mode = { "n", "i" } },
              ["<A-j>"] = { "preview_scroll_down", mode = { "n", "i" } },
              ["<A-k>"] = { "preview_scroll_up", mode = { "n", "i" } },
              ["<A-l>"] = { "preview_scroll_right", mode = { "n", "i" } },

              -- unbind
              ["<C-d>"] = false,
              ["<C-u>"] = false,
            },
          },
        },
      },
    })

    vim.keymap.set("n", "<leader>fc", snacks.picker.lines, { desc = "Snacks Picker: Find in current buffer" })
    vim.keymap.set("n", "<leader>fh", snacks.picker.help, { desc = "Snacks Picker: Find help tags" })
    vim.keymap.set("n", "<leader>fl", snacks.picker.lsp_references, { desc = "Snacks Picker: Find LSP references" })
    vim.keymap.set("n", "<leader>fb", snacks.picker.buffers, { desc = "Snacks Picker: Find buffer" })

    vim.keymap.set("n", "<leader>fw", function()
      snacks.picker.grep({ hidden = true })
    end, { desc = "Snacks Picker: Find word" })

    vim.keymap.set({ "n", "v" }, "<leader>fW", function()
      snacks.picker.grep_word({ hidden = true })
    end, { desc = "Snacks Picker: Find word under cursor or selected word" })

    vim.keymap.set("n", "<leader>fd", function()
      if snacks.git.get_root() then
        snacks.picker.git_files({ untracked = true })
      else
        snacks.picker.files({
          hidden = true,
          exclude = { "node_modules/" },
        })
      end
    end, { desc = "Snacks Picker: Find Files" })
  end,
}
