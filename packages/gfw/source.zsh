export PROXYCHAINS_CONF_FILE=${HOME}/.proxychains

alias pc4=proxychains4

proxy_help() {
	echo "Usage: proxy [options]"
	echo ""
	echo "Options:"
	echo "  on      Proxy On 开启代理，飞跃长城"
	echo "  off     Proxy Off"
}

local sshconfig="
## Github
Host github.com
	HostName github.com
	User git
		ProxyCommand nc -v -x 127.0.0.1:1086 %h %p"

proxy_on() {
	export http_proxy=http://127.0.0.1:6868;
	export https_proxy=$http_proxy;
	export HTTP_PROXY=$http_proxy;
	export HTTPS_PROXY=$http_proxy;

	## github
	git config --global http.https://github.com.proxy socks5://127.0.0.1:1086
	grep -qxF "Host github.com" "${HOME}/.ssh/config" || echo $sshconfig >> "${HOME}/.ssh/config"

	echo "代理开启 - ${http_proxy}"
}

proxy_off() {
	unset http_proxy;
	unset https_proxy;
	unset HTTP_PROXY;
	unset HTTPS_PROXY;

	## github
	git config --global --unset http.https://github.com.proxy
	sed -i "" '/## Github/{N;N;N;N;N;N;d;}' "${HOME}/.ssh/config"
	sed -i "" -e '$ d' "${HOME}/.ssh/config" # 删除奇怪的一个空行，没有好的解决办法

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
