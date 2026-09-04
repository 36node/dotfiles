## 本机 ZeroTier daemon 启停（launchd plist）
ZT_LAUNCHD="/Library/LaunchDaemons/com.zerotier.one.plist"

function zero() {
  case $1 in
  "start"*)
    echo "start zerotier"
    sudo launchctl load "$ZT_LAUNCHD"
    ;;
  "stop"*)
    echo "stop zerotier"
    sudo launchctl unload "$ZT_LAUNCHD"
    ;;
  "restart"*)
    echo "restart zerotier"
    sudo launchctl unload "$ZT_LAUNCHD"
    sleep 10
    sudo launchctl load "$ZT_LAUNCHD"
    ;;
  "info"*)
    sudo zerotier-cli info
    echo ""
    sudo zerotier-cli listnetworks
    ;;
  *)
    echo "Usage: zero <command>"
    echo ""
    echo "command:"
    echo "  start    开启 zerotier"
    echo "  stop     关闭 zerotier"
    echo "  restart  重启 zerotier"
    echo "  info     当前节点与入网连接情况"
    ;;
  esac
}
