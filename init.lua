-- Bootstrap lazy.nvim（首次启动自动克隆）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim.\n", "ErrorMsg" },
      { "See: https://github.com/folke/lazy.nvim\n", "WarningMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- 主配置：LazyVim + extras + 自定义插件
require("config.lazy")

-- 机器相关（python3 解析等）
require("config.machine")

-- 机器本地覆盖（可选，已 gitignore）：
--   复制 lua/config/local.example.lua 为 lua/config/local.lua
local local_file = vim.fn.stdpath("config") .. "/lua/config/local.lua"
if vim.uv.fs_stat(local_file) then
  require("config.local")
end
