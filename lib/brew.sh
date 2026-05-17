#!/bin/bash
#
# brew
#
# 安装策略：fail-fast
#   - 已安装：秒跳（让重跑代价很低）
#   - 安装失败：立即用 error 中断整个脚本，避免错误被后续日志淹没
#   - Ctrl+C：brew 收到 SIGINT 非 0 退出 → 触发 error → 干净中断
# 排查失败后重跑 ./install.sh 即可，前面装过的会自动跳过。

brew_install() {
  message "安装 ${1} ..."
  if brew list "$1" &>/dev/null; then
    success "已安装 ${1}"
    echo ""
    return 0
  fi
  brew install "$1" || error "安装 ${1} 失败，请手动排查后重跑 ./install.sh"
  success "安装成功 ${1}"
  echo ""
}

brew_cask_install() {
  message "安装 ${1} ..."
  if brew list --cask "$1" &>/dev/null; then
    success "已安装 ${1}"
    echo ""
    return 0
  fi
  brew install --cask "$1" || error "安装 ${1} 失败，请手动排查后重跑 ./install.sh"
  success "安装成功 ${1}"
  echo ""
}
