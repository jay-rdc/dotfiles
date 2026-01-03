vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-on-attach-keymaps", {}),
  callback = function(args)
    local function opts(desc)
      return { buffer = args.buf, remap = false, desc = desc or "" }
    end

    local function custom_hover()
      vim.lsp.buf.hover({
        border = "rounded"
      })
    end

    local function get_diagnostic_float_win()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative ~= "" and vim.w[win].diagnostic then
          return win
        end
      end
    end

    -- for JS filetypes
    local ft = vim.bo[args.buf].filetype
    local js_ft = {
      javascript = true,
      typescript = true,
      javascriptreact = true,
      typescriptreact = true,
    }

    if js_ft[ft] then
      vim.keymap.set("n", "<leader>EF", function()
        vim.cmd("normal! mF")
        vim.cmd("silent! %!eslint_d --stdin --fix-to-stdout --stdin-filename % 2>/dev/null")
        vim.cmd("normal! `F")
      end, opts("eslint_d: Fix errors"))
    end

    -- LSP Actions
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("LSP: Go to definition"))
    vim.keymap.set("n", "K", custom_hover, opts("LSP: Hover"))
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts("LSP: Code action"))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("LSP: Rename"))
    vim.keymap.set({ "n", "v" }, "<leader>=", function()
      require("conform").format({ lsp_format = "fallback" })
    end, opts("LSP: Format"))
    vim.keymap.set("n", "<leader>lr", function()
      if not pcall(require("telescope.builtin").lsp_references) then
        vim.lsp.buf.references()
      end
    end, opts("LSP: References"))
    vim.keymap.set("n", "<leader>LR", "<cmd>LspRestart<CR>", opts("LSP: Restart Server"))

    -- Diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Diagnostics: Go to previous diagnostic"))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Diagnostics: Go to next diagnostic"))
    vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts("Diagnostics: Set quickfix list"))
    vim.keymap.set("n", "<leader>df", function()
      local existing = get_diagnostic_float_win()
      if existing then
        -- float already exists, enter it
        vim.api.nvim_set_current_win(existing)
        return
      end

      -- no existing float, open a new one
      local before = vim.api.nvim_tabpage_list_wins(0)
      vim.diagnostic.open_float()

      -- detect the newly-created window
      local after = vim.api.nvim_tabpage_list_wins(0)
      for _, w in ipairs(after) do
        if not vim.tbl_contains(before, w) then
          vim.api.nvim_set_current_win(w)
          return
        end
      end
    end, { desc = "Diagnostics: Open float" })
  end,
})
