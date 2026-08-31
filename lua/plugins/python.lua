-- Python / ruff：继承 LazyVim lang.python extra（默认 pyright + ruff）
-- 仅补充：让 ruff LSP 指向仓库内的 ruff.toml（随配置分发，跨机器一致）
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
            },
          },
        },
      },
    },
  },
}
