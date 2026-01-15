return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter').install({
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
  end,
}
