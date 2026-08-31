-- 全局选项：只覆盖 LazyVim 默认之外的少量项
local opt = vim.opt

-- 缩进：全局 2 空格（TS/Vue 生态），Python/SQL 单独 4 空格（见下方 autocmd）
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- 其它偏好
opt.scrolloff = 7
opt.updatetime = 100
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = "tab:▸ ,trail:·,nbsp:␣"

-- Python / SQL：4 空格缩进（PEP8 / 数据库脚本惯例）
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "sql" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})
