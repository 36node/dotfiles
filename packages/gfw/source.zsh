export PROXYCHAINS_CONF_FILE=${HOME}/.proxychains
export PROXYCHAINS_QUIET_MODE=1

alias pc4="proxychains4 -q"

proxy_help() {
	echo "Usage: proxy [options]"
	echo ""
	echo "Options:"
	echo "  on      Proxy On 开启代理，飞跃长城"
	echo "  off     Proxy Off"
}

proxy_on() {
	local_ip_v4=$(ifconfig | grep inet | grep -v inet6 | grep -v 127 | cut -d ' ' -f2 | head -n 1)

	export http_proxy=http://${local_ip_v4}:6868;
	export https_proxy=$http_proxy;
	export HTTP_PROXY=$http_proxy;
	export HTTPS_PROXY=$http_proxy;
	export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24,172.17.0.0/24

	## github
	git config --global http.https://github.com.proxy socks5://127.0.0.1:1086

	echo "代理开启 - ${http_proxy}"
}

proxy_off() {
	unset http_proxy;
	unset https_proxy;
	unset HTTP_PROXY;
	unset HTTPS_PROXY;

	## github
	git config --global --unset http.https://github.com.proxy

	echo "代理关闭"
}

function proxy() {
	if [[ -z "$1" ]]; then
		proxy_on
	else
		case "$1" in
			"on")
				proxy_on
				;;
			"off")
				proxy_off
				;;
			*)
				echo "Invalid option: $1"
				proxy_help
				;;
		esac
	fi
}

## restart zerotier
function zero() {
	case $1 in
	"start"*)
		echo "start zerotier"
		sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist
		;;
	"stop"*)
		echo "stop zerotier"
		sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist
		;;
	"restart"*)
		echo "restart zerotier"
		sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist
		sleep 10
		sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist
		;;
	*)
		echo "Usage: zero <command>"
		echo ""
		echo "command:"
		echo "  start    开启 zerotier"
		echo "  stop     关闭 zerotier"
		echo "  restart  重启 zerotier"
		;;
	esac
}
