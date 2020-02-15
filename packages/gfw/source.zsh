export PROXYCHAINS_CONF_FILE=~/.proxychains
export DYLD_INSERT_LIBRARIES=/usr/local/Cellar/proxychains-ng/4.13/lib/libproxychains4.dylib

function fuckgfw() {
  export DYLD_FORCE_FLAT_NAMESPACE=1
  export FUCKING_GFW=1
}

function offgfw() {
    unset DYLD_FORCE_FLAT_NAMESPACE;
    unset FUCKING_GFW;
}

