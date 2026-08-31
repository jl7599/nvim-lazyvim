-- 跨平台机器相关设置
-- Python 统一走 uv：优先项目根目录 .venv，否则回退系统 python3
local function resolve_python3()
  local root = vim.fs.root(0, { ".git", ".venv", "pyproject.toml", "uv.lock", "setup.py", "requirements.txt" })
  if root then
    local venv_python = root .. "/.venv/bin/python"
    if vim.fn.filereadable(venv_python) == 1 then
      return venv_python
    end
  end
  return vim.fn.exepath("python3")
end

vim.g.python3_host_prog = resolve_python3()

-- 禁用用不到的语言 provider
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
