#!/bin/sh
#
# zsh

brew_install zsh

## set zsh as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "$(which zsh)" ]]; then
  info "setting homebrew zsh as your shell (password required)"
  # sudo bash -c 'echo "$(which zsh)" >> /etc/shells'
  # chsh -s $(which zsh)
  sudo dscl . -change /Users/$USER UserShell $SHELL $(which zsh) > /dev/null 2>&1
fi

## oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "安装 oh-my-zsh ..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "安装成功 oh-my-zsh"
fi

## 第三方插件
brew_install zsh-completions # 补全
brew_install zsh-autosuggestions # 提示
brew_install zsh-syntax-highlighting # 高亮

## https://github.com/Powerlevel9k/powerlevel9k
brew tap sambadevi/powerlevel9k
brew_install powerlevel9k

## https://github.com/ryanoasis/nerd-fonts
brew tap homebrew/cask-fonts
brew_cask_install font-hack-nerd-font

## zshrc
link_file "$PWD/.zshrc" "$ZSHRC"
