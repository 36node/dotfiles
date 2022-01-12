#!/bin/sh
#
# terminal 相关安装

## set zsh as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "$(which zsh)" ]]; then
  info "setting zsh as your shell (password required)"
  # sudo bash -c 'echo "$(which zsh)" >> /etc/shells'
  # chsh -s $(which zsh)
  sudo dscl . -change /Users/$USER UserShell $SHELL $(which zsh) > /dev/null 2>&1
fi

## oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "安装 oh-my-zsh ..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "安装成功 oh-my-zsh"
fi

sed -i "" "s/plugins=.*/plugins=(brew git python macos pip)/" "$ZSHRC"

## 树形目录
brew_install tree

## 提示
brew_install zsh-autosuggestions

## 补全
brew_install zsh-completions

## 高亮
brew_install zsh-syntax-highlighting

## 简写跳转
brew_install autojump

## 安装 tmux
brew_install tmux

## 安装 fzf https://github.com/junegunn/fzf
brew_install fzf
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

## 字体
brew tap homebrew/cask-fonts
brew_cask_install font-fira-code-nerd-font
brew_cask_install font-fira-mono-nerd-font

## terminal 主题
open "$PWD/packages/terminal/Solarized Light.terminal"
open "$PWD/packages/terminal/Solarized Dark.terminal"

## 安装 powerline
brew_install romkatv/powerlevel10k/powerlevel10k
link_file "$PWD/packages/terminal/.p10k.zsh" "$HOME/.p10k.zsh"