#!/usr/bin/env bash
# 一键安装 LazyVim 配置所需系统依赖（自动识别 macOS / Ubuntu / WSL）
# 用法: bash scripts/setup.sh [--skip-font]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin) SCRIPT="$DIR/setup-macos.sh" ;;
  Linux) SCRIPT="$DIR/setup-ubuntu.sh" ;; # WSL 也走 Ubuntu 分支
  *)
    echo "❌ 不支持的平台: $(uname -s)（仅支持 macOS / Linux）" >&2
    exit 1
    ;;
esac

exec bash "$SCRIPT" "$@"
