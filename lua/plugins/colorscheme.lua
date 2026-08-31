-- 主题：gruvbox-material（默认）
-- LazyVim 默认自带 tokyonight；这里用更高优先级插件覆盖，启动即用 gruvbox-material。
return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,    -- 启动时立即加载，避免主题闪烁
    priority = 1000, -- 高于 LazyVim 默认主题，确保生效
    config = function()
      -- 背景风格：hard / medium / soft（medium 为官方默认）
      vim.g.gruvbox_material_background = "medium"
      -- 其它常用选项（按需取消注释）：
      -- vim.g.gruvbox_material_statusline_style = "original" -- 状态栏风格
      -- vim.g.gruvbox_material_float_style = "blend"         -- 浮窗风格
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
}
