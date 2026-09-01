-- 状态栏（lualine）：去掉最右侧的时钟（LazyVim 默认在 lualine_z 里显示 " HH:MM"）
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_z = {}
    end,
  },
}
