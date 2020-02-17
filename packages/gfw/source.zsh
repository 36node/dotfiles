export PROXYCHAINS_CONF_FILE=~/.proxychains

alias pc4=proxychains4

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
}

proxy_off() {
	unset http_proxy;
	unset https_proxy;
	unset HTTP_PROXY;
	unset HTTPS_PROXY;
}

function proxy() {

	while test $# -gt 0; do
		case "$1" in
			"on")
				proxy_on
				echo "代理开启 - ${http_proxy}"
				exit
				;;
			"off")
				echo "代理关闭"
				proxy_off
				exit
				;;
			*)
				echo "Invalid option: $1"
				proxy_help
				exit
				;;
		esac
		shift
	done

	proxy_on
	echo "代理开启 - ${http_proxy}"
}
