return {
  "stevearc/oil.nvim",
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  config = function()
    local oil = require("oil")

    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    local function normalize_windows_path(path)
      -- Convert backslashes to forward slashes
      path = path:gsub("\\", "/")

      -- Convert "C:/..." -> "/C/..."
      path = path:gsub("^([A-Za-z]):/", "/%1/")

      -- Ensure trailing slash
      if not path:match("/$") then
        path = path .. "/"
      end

      return path
    end

    oil.setup({
      view_options = { show_hidden = true },
      preview_win = { preview_method = "load" },
      float = {
        get_win_title = function(winid)
          local raw_cwd = vim.fn.getcwd()

          local cwd = is_windows and normalize_windows_path(raw_cwd) or (raw_cwd .. "/")
          local cwd_escaped = vim.pesc(cwd)

          local buf = vim.api.nvim_win_get_buf(winid)
          local file_path = vim.api.nvim_buf_get_name(buf):gsub("^oil://", "")
          local file_path_norm = is_windows and normalize_windows_path(file_path) or file_path

          local relative_path = file_path_norm:gsub("^" .. cwd_escaped, "./")

          return " " .. relative_path .. " "
        end
      },
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, mode = "n" },
        ["<C-s>"] = { "actions.select", opts = { horizontal = true }, mode = "n" },
        ["<A-p>"] = { "actions.preview", mode = "n" },
        ["<A-h>"] = { "actions.preview_scroll_left", mode = "n" },
        ["<A-j>"] = { "actions.preview_scroll_down", mode = "n" },
        ["<A-k>"] = { "actions.preview_scroll_up", mode = "n" },
        ["<A-l>"] = { "actions.preview_scroll_right", mode = "n" },

        -- unbind
        ["<C-h>"] = false,
        ["<C-p>"] = false,
      },
    })

    vim.keymap.set("n", "<leader>e", oil.toggle_float, { desc = "Oil: File browser" })
  end,
}
