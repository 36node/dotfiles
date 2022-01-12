#!/bin/sh
#
# 翻墙

brew_install proxychains-ng
brew_install shadowsocksx-ng
brew_install clashx

## create links
link_file "$PWD/packages/gfw/ShadowsocksX-NG.symlink" "$HOME/.ShadowsocksX-NG"
link_file "$PWD/packages/gfw/proxychains.symlink" "$HOME/.proxychains"
