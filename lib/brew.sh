#!/bin/bash
#
# brew bundle 辅助
#
# 软件清单都写在 Brewfile 里：
#   Brewfile                    基础软件（完整安装时总会装）
#   packages/<name>/Brewfile    各 package 的软件（随 install.conf 的 PACKAGES 选择）
#   Brewfile.extra              选装软件（由 INSTALL_EXTRA 控制）
#
# 安装策略：fail-fast
#   - 已安装：跳过，不升级（--no-upgrade，让重跑代价很低；升级请自己 brew upgrade）
#   - 安装失败：立即用 error 中断整个脚本，避免错误被后续日志淹没
#   - Ctrl+C：brew 收到 SIGINT 非 0 退出 → 触发 error → 干净中断
# 排查失败后重跑 ./install.sh 即可，前面装过的会自动跳过。

# 按某个 Brewfile 安装缺失的软件
brew_bundle() {
  local file=$1
  message "安装 ${file} 里的软件 ..."
  brew bundle install --no-upgrade --file="$file" \
    || error "安装 ${file} 失败，请手动排查后重跑（mas 条目需要先登录 App Store）"
  success "完成 ${file}"
  echo ""
}

# 输出本机选中的 Brewfile 列表（每行一个，相对仓库根目录）
#   $1: all  → 根 Brewfile + 全部 packages + Brewfile.extra（判断「是否在任一清单里」用）
#       其他 → 根 Brewfile + PACKAGES 里的 packages（+ INSTALL_EXTRA=true 时的 Brewfile.extra）
# 依赖调用方已加载 install.conf（PACKAGES / INSTALL_EXTRA）
selected_brewfiles() {
  local scope=$1 pkg
  echo "Brewfile"
  if [ "$scope" = "all" ] || ! declare -p PACKAGES &>/dev/null; then
    for pkg in packages/*/Brewfile; do
      [ -f "$pkg" ] && echo "$pkg"
    done
  else
    for pkg in "${PACKAGES[@]}"; do
      [ -f "packages/$pkg/Brewfile" ] && echo "packages/$pkg/Brewfile"
    done
  fi
  case "${scope}:${INSTALL_EXTRA:-}" in
    all:*|*:true|*:TRUE|*:yes|*:YES|*:y|*:Y|*:1)
      [ -f Brewfile.extra ] && echo "Brewfile.extra"
      ;;
  esac
  return 0
}
