export PROXYCHAINS_CONF_FILE=~/.proxychains
export DYLD_INSERT_LIBRARIES=/usr/local/Cellar/proxychains-ng/4.13/lib/libproxychains4.dylib

gfw_help() {
	echo "Usage: gfw [options]"
	echo ""
	echo "Options:"
	echo "  on      Greate Fire Wall On"
	echo "  off     Greate Fire Wall Off == 开启代理，飞跃长城"
}

function gfw() {

  while test $# -gt 0; do
  	case "$1" in
  		"off")
        export DYLD_FORCE_FLAT_NAMESPACE=1
        export GFW_OFF=1
  			;;
  		"on")
        unset DYLD_FORCE_FLAT_NAMESPACE;
        unset GFW_OFF;
  			;;
  		*)
  			echo "Invalid option: $1"
  			gfw_help
        exit
  			;;
  	esac
  	shift
  done
}
