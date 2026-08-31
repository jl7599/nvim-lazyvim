-- 自定义自动命令（沿用旧配置里实用的几个习惯）
local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- 恢复上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 1 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, { mark[1], mark[2] })
    end
  end,
})

-- 终端打开时自动进入 insert 模式
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Python：保存前自动执行 ruff 修复（lint 自动修复；格式化由 LazyVim format-on-save 负责）
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*.py",
  callback = function()
    local client = vim.lsp.get_clients({ name = "ruff", bufnr = 0 })[1]
    if not client then
      return
    end
    -- 请求 ruff 的 Fix all code action，有可修复项就应用到当前 buffer
    local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
    params.context = { only = { "source.fixAll.ruff" } }
    vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, _, result)
      if err then
        return
      end
      for _, action in ipairs(result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
        end
      end
    end)
  end,
})
