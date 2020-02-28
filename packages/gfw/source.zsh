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
	export http_proxy=http://127.0.0.1:6868;
	export https_proxy=$http_proxy;
	export HTTP_PROXY=$http_proxy;
	export HTTPS_PROXY=$http_proxy;

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
