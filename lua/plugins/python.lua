-- Python / ruff：继承 LazyVim lang.python extra（默认 pyright + ruff）
-- 补充：
--   1. 让 ruff LSP 指向仓库内的 ruff.toml（随配置分发，跨机器一致）
--   2. 开启 "Fix all" code action，配合 lua/config/autocmds.lua 保存时自动修复
--   3. pyright 按项目自动探测 venv：
--      pyright 本身不会发现项目根目录的 .venv（VS Code 里是 Pylance 客户端帮它探测的），
--      在 nvim + LazyVim（Nvim 0.11 原生 LSP）里没人传这个信息，它就会回退到 PATH 上的
--      系统 python3，导致 "Import xxx could not be resolved"。
--      Nvim 0.11 没有 on_new_config 钩子，这里用 on_init：等 client 起来后把
--      pythonPath 指到 <root>/.venv/bin/python（回退 venv/），再通知服务端重载配置。
local ruff_config = vim.fn.stdpath("config") .. "/ruff.toml"

local function resolve_venv_python(root)
  if not root then
    return nil
  end
  for _, name in ipairs({ ".venv", "venv" }) do
    local python = root .. "/" .. name .. "/bin/python"
    if vim.fn.filereadable(python) == 1 then
      return python
    end
  end
  return nil
end

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
        pyright = {
          on_init = function(client, _)
            local python = resolve_venv_python(client.config.root_dir)
            if python then
              client.settings = client.settings or {}
              client.settings.python = client.settings.python or {}
              client.settings.python.pythonPath = python
              client.notify("workspace/didChangeConfiguration", { settings = client.settings })
            end
          end,
        },
      },
    },
  },
}
