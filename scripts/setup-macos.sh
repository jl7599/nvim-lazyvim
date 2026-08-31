#!/usr/bin/env bash
# macOS 依赖安装（Homebrew）
# 用法: bash scripts/setup-macos.sh [--skip-font]
set -euo pipefail

for arg in "$@"; do
  [[ "$arg" == "--skip-font" ]] && SKIP_FONT=1
done

command -v brew >/dev/null 2>&1 || {
  echo "❌ 未检测到 Homebrew，请先安装: https://brew.sh" >&2
  exit 1
}

echo "==> 更新 Homebrew"
brew update

echo "==> 安装依赖: neovim git ripgrep fd fzf lazygit node uv"
brew install neovim git ripgrep fd fzf lazygit node uv

if [[ "${SKIP_FONT:-0}" != "1" ]]; then
  echo "==> 安装 Nerd Font (JetBrainsMono Nerd Font)"
  # 若 cask 名失效，用 `brew search nerd-font` 查找最新名称
  brew install --cask font-jetbrainsmono-nerd-font \
    || echo "⚠️ 字体安装失败，可稍后手动执行: brew install --cask font-jetbrainsmono-nerd-font"
fi

echo ""
echo "✅ macOS 依赖安装完成。版本信息："
echo "   nvim   : $(nvim --version 2>/dev/null | head -1)"
echo "   lazygit: $(lazygit --version 2>/dev/null | head -1 || echo n/a)"
echo "   uv     : $(uv --version 2>/dev/null || echo n/a)"
echo ""
echo "下一步：在终端执行 nvim，首次启动会自动安装插件。"
