vim.pack.add({
  -- independent
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/mbbill/undotree",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  -- with dependencies

  -- Oil
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-mini/mini.icons",

  -- Harpoon
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  "https://github.com/nvim-lua/plenary.nvim",

  -- Completion
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/L3MON4D3/LuaSnip",

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

-- Run plugin setup configs located in /lua/config/plugins/
local plugin_conf_dir = vim.fn.stdpath("config") .. "/lua/config/plugins/*.lua"

local plugin_files = vim.fn.glob(plugin_conf_dir, true, true)

for _, filepath in ipairs(plugin_files) do
  local module_name = vim.fn.fnamemodify(filepath, ":t:r")

  local ok, err = pcall(require, "config.plugins." .. module_name)

  if not ok then
    vim.notify("Failed to load config.plugins." .. module_name .. "\n" .. err, vim.log.levels.ERROR)
  end
end

-- vim.pack User Commands
vim.api.nvim_create_user_command("PackUpdate", function(opts)
  if opts.args ~= "" then
    -- update specific plugins
    local plugins = vim.split(opts.args, "%s+", { trimempty = true })
    vim.pack.update(plugins)
  else
    -- update all
    vim.pack.update()
  end
end, { desc = "Update all plugins or specific ones", nargs = "*" })

vim.api.nvim_create_user_command("PackDel", function(opts)
  vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (space separated)" })

vim.api.nvim_create_user_command("PackCheck", function()
  local inactive = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()

  if #inactive == 0 then
    vim.notify("🆗 No inactive plugins found!", vim.log.levels.INFO)
    return
  end

  vim.print("😴 Inactive plugins :")
  print(" ")

  for _, name in ipairs(inactive) do
    print(name)
  end

  print(" ")

  local choice = vim.fn.confirm(
    "Delete ALL inactive plugins from disk?",
    "&Yes\n&No",
    2 -- default = No
  )

  if choice == 1 then
    vim.pack.del(inactive)
    vim.notify("🗑️ Deleted " .. #inactive .. " inactive plugin(s)", vim.log.levels.INFO)
    print("Inactive plugins deleted!")
    vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
  else
    vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
  end
end, { desc = "List inactive plugins and select to delete" })
