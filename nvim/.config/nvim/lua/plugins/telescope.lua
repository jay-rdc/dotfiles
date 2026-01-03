return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    local themes = require("telescope.themes")
    local builtin = require("telescope.builtin")
    local lga_actions = require("telescope-live-grep-args.actions")

    local show_preview_on_startup = {
      preview = { hide_on_startup = false },
    }

    telescope.setup({
      defaults = {
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.6,
            width = 0.8,
            height = 0.8,
          },
        },
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        preview = { hide_on_startup = true },
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<Esc>"] = actions.close,
            ["<C-s>"] = actions.file_split,
            ["<A-p>"] = actions_layout.toggle_preview,
            ["<A-h>"] = actions.preview_scrolling_left,
            ["<A-j>"] = actions.preview_scrolling_down,
            ["<A-k>"] = actions.preview_scrolling_up,
            ["<A-l>"] = actions.preview_scrolling_right,
            ["<A-S-h>"] = actions.results_scrolling_left,
            ["<A-S-j>"] = actions.results_scrolling_down,
            ["<A-S-k>"] = actions.results_scrolling_up,
            ["<A-S-l>"] = actions.results_scrolling_right,

            -- unbind
            ["<C-d>"] = false,
            ["<C-u>"] = false,
            ["<C-x>"] = false,
          },
        },
      },
      pickers = {
        current_buffer_fuzzy_find = show_preview_on_startup,
        live_grep = show_preview_on_startup,
        lsp_references = show_preview_on_startup,
      },
      extensions = {
        ["ui-select"] = {
          themes.get_cursor(),
        },
        live_grep_args = {
          auto_quoting = true,
          preview = { hide_on_startup = false },
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
            },
          },
        },
      },
    })
    telescope.load_extension("ui-select")
    telescope.load_extension("live_grep_args")

    vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "Telescope: Find in current file" })
    vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Telescope: Find word" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Find help tags" })
    vim.keymap.set("n", "<leader>fd", function()
      if not pcall(builtin.git_files, { show_untracked = true }) then
        builtin.find_files()
      end
    end, { desc = "Telescope: Find files" })
  end
}
