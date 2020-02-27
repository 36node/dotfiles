#! /bin/zsh

###############################################################################
# 这个文件设置 socks 代理，使得像 Mail App 等可以翻墙
# 不是很完善，请手动执行
# 可以考虑集成到系统的 automator
###############################################################################
 
wifi='Wi-Fi'
 
# proxy 
# networksetup -setproxyautodiscovery "${wifi}" on
networksetup -setsocksfirewallproxy "${wifi}" 127.0.0.1 1086