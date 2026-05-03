local augroup = vim.api.nvim_create_augroup("user-config-group", {})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  once = true,
  callback = function()
    local bufs = vim.api.nvim_list_bufs()
    if #bufs > 1 then
      local prev_buf = vim.fn.bufnr("#")
      -- Check if the previous buffer was unnamed, empty, and unmodified
      if
        prev_buf > 0
        and vim.api.nvim_buf_get_name(prev_buf) == ""
        and vim.api.nvim_buf_get_option(prev_buf, "buftype") == ""
        and not vim.api.nvim_buf_get_option(prev_buf, "modified")
      then
        vim.api.nvim_buf_delete(prev_buf, { force = true })
      end
    end
  end,
})
