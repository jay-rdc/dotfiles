require("nvim-treesitter").install({
  "bash",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "html",
  "ini",
  "javascript",
  "json",
  "lua",
  "markdown",
  "regex",
  "typescript",
  "vim",
  "vimdoc",
  "zsh",
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("treesitter-update", {}),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      vim.cmd("TSUpdate")
    end
  end,
})
