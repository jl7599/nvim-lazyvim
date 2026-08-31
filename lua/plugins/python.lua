-- Python / ruff：继承 LazyVim lang.python extra（默认 pyright + ruff）
-- 补充：
--   1. 让 ruff LSP 指向仓库内的 ruff.toml（随配置分发，跨机器一致）
--   2. 开启 "Fix all" code action，配合 lua/config/autocmds.lua 保存时自动修复
local ruff_config = vim.fn.stdpath("config") .. "/ruff.toml"

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          init_options = {
            settings = {
              lineLength = 88,
              configuration = vim.fn.filereadable(ruff_config) == 1 and ruff_config or nil,
              codeAction = { fixAll = { enable = true } }, -- 提供 source.fixAll.ruff
            },
          },
        },
      },
    },
  },
}
