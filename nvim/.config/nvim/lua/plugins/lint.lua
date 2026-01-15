return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    vim.env.ESLINT_D_PPID = vim.fn.getpid()
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      css = { "stylelint" },
      scss = { "stylelint" },
    }

    lint.linters.eslint_d = require("lint.util").wrap(lint.linters.eslint_d, function(diagnostic)
      local error = "Error: Could not find config file"
      if diagnostic.message:find(error) then
        vim.notify_once("eslint_d " .. error, vim.log.levels.WARN)
        return nil
      end
      return diagnostic
    end)

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = vim.api.nvim_create_augroup("lint", {}),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
