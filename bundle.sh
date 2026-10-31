#!/bin/bash
#
# 对比本机已装软件和 Brewfile 清单（不会卸载任何东西）
#
#   ./bundle.sh check      清单里有、本机没装的（按 install.conf 的 PACKAGES / INSTALL_EXTRA）
#   ./bundle.sh unlisted   本机装了、但所有 Brewfile 里都没有的（顶层 formula、cask、tap）
#   ./bundle.sh install    补装 check 列出的缺失软件（不升级，不跑 package 的 install.sh）
#
# 想把 unlisted 里的某个软件纳入管理：写进对应的 Brewfile 再提交
# 想卸掉它：自己 brew uninstall（本脚本不替你删）

cd "$(dirname "$0")"

source lib/echo.sh
source lib/brew.sh

[ -f install.conf ] && . ./install.conf

# 把选中的 Brewfile 拼成一份，交给 brew bundle --file=-
combined() {
  local f
  selected_brewfiles "$1" | while IFS= read -r f; do
    cat "$f"
    echo ""
  done
}

case "${1:-}" in
  check)
    message "检查以下 Brewfile 是否都已安装："
    selected_brewfiles | sed 's/^/  /'
    combined | brew bundle check --no-upgrade --verbose --file=-
    ;;
  unlisted)
    message "本机装了、但不在任何 Brewfile 里的软件（只列出，不会卸载）："
    ## 不带 --force 时 cleanup 只列出不卸载；它只在 stdin 和 stdout 都是终端时才会询问是否卸载，
    ## 这里 stdin 是管道、stdout 被 $() 捕获，所以既不会询问也不会删任何东西
    output=$(combined all | brew bundle cleanup --file=- 2>&1)
    ## 只保留「会卸载的 formula / cask、会 untap 的 tap」几段和报错，
    ## 去掉 brew cleanup 的旧版本/缓存预览和依赖图警告
    report=$(echo "$output" | awk '
      /^Would (uninstall|zap) formulae/ { keep = 1; print "formula："; next }
      /^Would (uninstall|zap) casks/    { keep = 1; print "cask："; next }
      /^Would untap/                    { keep = 1; print "tap："; next }
      /^Would (uninstall|untap|zap)/    { keep = 1; print; next }
      /^(Would|Run|Warning|==>)/     { keep = 0 }
      /^Error/                       { print; next }
      keep && NF                     { print "  " $0 }
    ')
    if [ -z "$report" ]; then
      success "没有清单外的软件"
    else
      echo "$report"
    fi
    ;;
  install)
    message "按以下 Brewfile 补装缺失的软件："
    selected_brewfiles | sed 's/^/  /'
    combined | brew bundle install --no-upgrade --file=- \
      || error "安装失败，请手动排查后重跑（mas 条目需要先登录 App Store）"
    ;;
  *)
    echo "Usage: ./bundle.sh check|unlisted|install"
    echo ""
    echo "  check      清单里有、本机没装的（按 install.conf 的 PACKAGES / INSTALL_EXTRA）"
    echo "  unlisted   本机装了、但所有 Brewfile 里都没有的（只列出，不卸载）"
    echo "  install    补装缺失的软件（不升级，不跑 package 的 install.sh）"
    exit 1
    ;;
esac
