-- LazyVim 主配置
-- 启用/停用功能用 :LazyExtras；改键位用 lua/config/keymaps.lua
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 语言支持（按需增删）
    { import = "lazyvim.plugins.extras.lang.python" },     -- pyright + ruff
    { import = "lazyvim.plugins.extras.lang.typescript" }, -- vtsls（vue 依赖它）
    { import = "lazyvim.plugins.extras.lang.vue" },
    -- { import = "lazyvim.plugins.extras.lang.go" },         -- gopls（暂时不需要）
    { import = "lazyvim.plugins.extras.lang.markdown" },

    -- 自定义插件（lua/plugins/*.lua）
    { import = "plugins" },
  },
  defaults = {
    lazy = false,  -- 自定义插件默认启动时加载
    version = false, -- 始终使用最新 commit
  },
  install = { colorscheme = { "gruvbox-material", "habamax" } }, -- 首个即默认主题，首次安装时确保可用
  checker = { enabled = false }, -- 不自动检查更新，手动 :Lazy update
  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
