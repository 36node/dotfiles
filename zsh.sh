#!/bin/sh
#
# zsh


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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  success "安装成功 oh-my-zsh"
fi

## 第三方插件
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  info "安装 zsh-autosuggestions ..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions --depth=1
  success "安装成功 zsh-autosuggestions"
fi

if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
  info "安装 zsh-syntax-highlighting ..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting --depth=1
  success "安装成功 zsh-syntax-highlighting"
fi

if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]]; then
  info "安装 zsh-completions ..."
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions --depth=1
  success "安装成功 zsh-completions"
fi

## 主题 https://github.com/Powerlevel9k/powerlevel9k
if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]]; then
  info "安装 powerlevel9k ..."
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k --depth=1
  success "安装成功 powerlevel9k"
fi

## https://github.com/ryanoasis/nerd-fonts
brew tap homebrew/cask-fonts
brew_cask_install font-hack-nerd-font

## zshrc
link_file "$PWD/.zshrc" "$ZSHRC"
