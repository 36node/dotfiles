#!/bin/sh
#
# vim

## vim
brew_install vim

## create links
link_file "$PWD/packages/vim/vimrc.symlink" "$HOME/.vimrc"
