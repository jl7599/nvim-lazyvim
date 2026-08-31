# nvim-lazyvim

基于 [LazyVim](https://www.lazyvim.org) 的 Neovim 配置，跨平台（macOS / Ubuntu / WSL）统一体验。
插件管理交给 LazyVim / lazy.nvim，本仓库只保留个人差异（主题、缩进、ruff、机器本地覆盖）与安装脚本。

## 特性一览

- 主题：gruvbox-material（hard / medium / soft 三档背景）
- 语言支持：Python、TypeScript、Vue、Markdown（go 已注释，按需开启）
- LSP：Mason 首次打开文件自动安装，无需手动装
- 缩进：全局 2 空格，Python / SQL 自动切 4 空格
- ruff：统一使用仓库内 `ruff.toml`，保存 `.py` 时自动修复 lint
- Python：优先项目 `.venv`，回退系统 python3（uv 工作流友好）

## 新机器快速开始

```bash
git clone <仓库地址> ~/.config/nvim
bash ~/.config/nvim/scripts/setup.sh   # 自动识别 macOS/Ubuntu，装系统依赖
nvim                                  # 首次启动自动安装全部插件
```

- 要求 Neovim ≥ 0.11.2（脚本会装最新 stable）
- 终端建议使用 Nerd Font（脚本默认安装 JetBrainsMono Nerd Font；跳过：`bash scripts/setup.sh --skip-font`）
- WSL 走 Ubuntu 分支；Windows Terminal 需手动把字体设为 JetBrainsMono Nerd Font
- 语言服务器不用手动装：首次打开对应语言文件时 Mason 自动安装

## 目录结构

```
nvim-lazyvim/
├── init.lua                  # 入口：bootstrap lazy.nvim
├── lazy-lock.json            # 插件版本锁定（提交，保证多机一致）
├── ruff.toml                 # ruff 配置（随仓库分发）
├── lua/
│   ├── config/
│   │   ├── lazy.lua          # LazyVim + extras + 自定义插件
│   │   ├── options.lua       # 全局选项（缩进等）
│   │   ├── keymaps.lua       # 键位（默认用 LazyVim 原生）
│   │   ├── autocmds.lua      # 自动命令
│   │   ├── machine.lua       # 机器相关（python3 解析）
│   │   └── local.example.lua # 机器本地覆盖模板
│   └── plugins/
│       ├── colorscheme.lua   # 主题：gruvbox-material
│       └── python.lua        # ruff LSP 指向仓库内 ruff.toml
└── scripts/
    ├── setup.sh              # 入口：自动识别 OS
    ├── setup-macos.sh        # Homebrew
    └── setup-ubuntu.sh       # apt（含 WSL）
```

## 已启用的 LazyVim extras

| extra | 说明 |
| --- | --- |
| `lang.python` | pyright + ruff（保留原有 ruff 工作流） |
| `lang.typescript` | vtsls |
| `lang.vue` | Vue 语言服务（依赖 typescript） |
| `lang.markdown` | Markdown |

> `lang.go`（gopls）已在 `lua/config/lazy.lua` 中注释，需要时去掉注释即可。

增删用 `:LazyExtras`，或直接改 `lua/config/lazy.lua`。

## 个人定制说明

- **主题**：gruvbox-material，配置见 `lua/plugins/colorscheme.lua`。
- **ruff**：`ruff.toml` 在仓库根目录（继承自原 `~/.config/python/ruff.toml`），`lua/plugins/python.lua` 让 ruff LSP 指向它，跨机器一致。
- **Python 保存自动修复**：保存 `.py` 时自动执行 ruff 的 lint 修复（基于 ruff LSP 的 `Fix all`，见 `lua/config/autocmds.lua`），格式化仍由 LazyVim 的 format-on-save 负责。
- **缩进**：全局 2 空格；Python/SQL 自动切 4 空格（`options.lua`）。
- **机器本地覆盖**：复制 `lua/config/local.example.lua` 为 `lua/config/local.lua`（已 gitignore），放某台机器专用配置。
- **python3 解释器**：`lua/config/machine.lua` 优先项目 `.venv/bin/python`，回退系统 python3。

## 旧键位对照（想加回时参考）

新配置默认全部使用 LazyVim 原生键位（`<leader>` = 空格），常用速查：

| 动作 | LazyVim 默认 |
| --- | --- |
| 查找文件 | `<leader>ff` |
| 切换 buffer | `<leader>fb` |
| 最近文件 | `<leader>fr` |
| 文件树 | `<leader>e` |
| 关闭 buffer | `<leader>bd` |
| 终端 | `<leader>ft` / `<C-/>` |
| Git 状态 (lazygit) | `<leader>gg` |
| 诊断上/下 | `[d` / `]d` |
| LSP 重命名 | `<leader>cr` |
| 格式化 | `<leader>cf` |

旧习惯（`gb`/`gbd`、`F3`、`sh`/`sv`、`te` 等）如果实在想保留，在 `lua/config/keymaps.lua` 里加回即可。
完整键位：`<leader>?`（which-key）或 https://www.lazyvim.org/keymaps

## 主题

默认 **gruvbox-material**（`lua/plugins/colorscheme.lua`）。

- 背景三档：`hard` / `medium` / `soft`，改 `vim.g.gruvbox_material_background` 即可（默认 `medium`）
- 更多选项（状态栏 / 浮窗风格等）见 <https://github.com/sainnhe/gruvbox-material>

想换回 tokyonight 或其它主题：

1. 删除或注释 `lua/plugins/colorscheme.lua` 中的 gruvbox-material（LazyVim 默认自带 tokyonight，删掉即回退）
2. 把 `lua/config/lazy.lua` 里 `install.colorscheme` 的第一项改回 `"tokyonight"`

## 日常维护

- 更新插件：`:Lazy update`（更新后提交 `lazy-lock.json`）
- 新增插件：在 `lua/plugins/` 新建 `xxx.lua`，重启后自动安装并写入锁文件
- 安装新语言支持：`:LazyExtras` 勾选对应 extra
- 卸载重装：删除 `~/.config/nvim`、`~/.local/share/nvim`、`~/.local/state/nvim` 后重新 clone

## 常见问题

- **插件安装慢/失败**：国内网络请先配置代理再启动 nvim；或在 `lua/config/local.lua` 里设置 git 代理。
- **fd/bat 找不到**：Ubuntu 上脚本已软链接 `fdfind`→`fd`、`batcat`→`bat`；手动装的话记得补软链接。
- **CoC 旧配置**：coc.nvim / coc-settings.json 已弃用，LSP 由 mason + blink.cmp 接管，无需迁移。
