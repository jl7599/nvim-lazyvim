#!/usr/bin/env bash
# Ubuntu / Debian（含 WSL）依赖安装
# 用法: bash scripts/setup-ubuntu.sh [--skip-font]
set -euo pipefail

for arg in "$@"; do
  [[ "$arg" == "--skip-font" ]] && SKIP_FONT=1
done

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)        LINUX_ARCH="x86_64" ;;
  aarch64|arm64) LINUX_ARCH="arm64" ;;
  *) echo "❌ 不支持的架构: $ARCH" >&2; exit 1 ;;
esac

echo "==> 安装系统包（需要 sudo）"
sudo apt-get update
sudo apt-get install -y \
  git curl unzip ca-certificates \
  ripgrep fd-find fzf bat \
  nodejs npm \
  python3 python3-venv

# Ubuntu 的 fd/bat 二进制名不同（fdfind/batcat），统一软链接
mkdir -p "$HOME/.local/bin"
ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"

# 确保 ~/.local/bin 在 PATH（bash/zsh 都写入）
if ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [[ -f "$rc" ]] && ! grep -q 'HOME/.local/bin' "$rc"; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc"
      echo "   已将 ~/.local/bin 加入 PATH（$rc）"
    fi
  done
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "==> 安装 Neovim（官方 release tarball，apt 版本太旧）"
NVIM_VER="${NVIM_VERSION:-$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest | grep -o '"tag_name": *"v[^"]*"' | head -1 | cut -d'"' -f4 | tr -d v)}"
echo "   版本: v${NVIM_VER}"
curl -fL "https://github.com/neovim/neovim/releases/download/v${NVIM_VER}/nvim-linux-${LINUX_ARCH}.tar.gz" -o /tmp/nvim.tar.gz
tar -C "$HOME/.local" -xzf /tmp/nvim.tar.gz
ln -sf "$HOME/.local/nvim-linux-${LINUX_ARCH}/bin/nvim" "$HOME/.local/bin/nvim"

echo "==> 安装 lazygit（官方 release tarball）"
LG_VER="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -o '"tag_name": *"v[^"]*"' | head -1 | cut -d'"' -f4)"
echo "   版本: ${LG_VER}"
curl -fL "https://github.com/jesseduffield/lazygit/releases/download/${LG_VER}/lazygit_${LG_VER#v}_Linux_${LINUX_ARCH}.tar.gz" -o /tmp/lazygit.tar.gz
tar -C /tmp -xzf /tmp/lazygit.tar.gz
mv -f /tmp/lazygit "$HOME/.local/bin/lazygit"
chmod +x "$HOME/.local/bin/lazygit"

echo "==> 安装 uv（Python 包管理）"
curl -LsSf https://astral.sh/uv/install.sh | sh \
  || echo "⚠️ uv 安装失败，可稍后手动执行: curl -LsSf https://astral.sh/uv/install.sh | sh"

if [[ "${SKIP_FONT:-0}" != "1" ]]; then
  echo "==> 安装 Nerd Font (JetBrainsMono Nerd Font)"
  mkdir -p "$HOME/.local/share/fonts"
  curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -o /tmp/jbm.zip
  unzip -o -q /tmp/jbm.zip -d "$HOME/.local/share/fonts"
  fc-cache -f >/dev/null 2>&1 || true
fi

echo ""
echo "✅ Ubuntu 依赖安装完成。版本信息："
echo "   nvim   : $(nvim --version 2>/dev/null | head -1 || echo '需重新打开终端生效')"
echo "   lazygit: $(lazygit --version 2>/dev/null | head -1 || echo n/a)"
echo "   uv     : $(uv --version 2>/dev/null || echo n/a)"
echo ""
echo "注意："
echo "  - WSL 用户还需在 Windows Terminal 设置中把字体改为 JetBrainsMono Nerd Font。"
echo "  - 重新打开终端后执行 nvim，首次启动会自动安装插件。"
