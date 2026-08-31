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
