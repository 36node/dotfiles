#!/bin/bash
#
# terminal 相关安装

## set zsh as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "$(which zsh)" ]]; then
  message "setting zsh as your shell (password required)"
  # sudo bash -c 'echo "$(which zsh)" >> /etc/shells'
  # chsh -s $(which zsh)
  sudo dscl . -change /Users/$USER UserShell $SHELL $(which zsh) > /dev/null 2>&1
fi

## 软件由同目录 Brewfile 安装，这里只做配置

## ghostty 终端
mkdir -p "$HOME/.config/ghostty"
link_file "$PWD/packages/terminal/ghostty/config" "$HOME/.config/ghostty/config"

## macOS 自带 Terminal：默认 profile 换成 Nerd Font，否则 starship 图标显示成方框
## Terminal 的字体存在 plist 的二进制归档里，用 AppleScript 改最稳；用的是 PostScript 名
TERMINAL_PROFILE=$(defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null || echo "Basic")
osascript -e "tell application \"Terminal\" to set font name of settings set \"$TERMINAL_PROFILE\" to \"JetBrainsMonoNFM-Regular\"" \
  -e "tell application \"Terminal\" to set font size of settings set \"$TERMINAL_PROFILE\" to 14" > /dev/null \
  && success "Terminal「$TERMINAL_PROFILE」字体已设为 JetBrainsMono Nerd Font Mono"

## starship prompt
mkdir -p "$HOME/.config"
link_file "$PWD/packages/terminal/starship/starship.toml" "$HOME/.config/starship.toml"

## antidote 插件管理器（替代 oh-my-zsh，更轻量）
## 文档：https://getantidote.github.io/
link_file "$PWD/packages/terminal/zsh_plugins.txt" "$HOME/.zsh_plugins.txt"

## delta 装完默认不会被 git 用到，需要把它注册成 git 的 pager。
## git config --global 是幂等的（重复写只覆盖、不堆叠），每次 install 重写一遍最稳。
## 注：如果你的 ~/.gitconfig 里已经手动配过 core.pager 或 interactive.diffFilter，
##     这里会覆盖。希望保留自定义配置就把下面这块注释掉。
git config --global core.pager 'delta'
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true        # n / N 在 hunk 间跳转
git config --global delta.line-numbers true    # 显示行号
git config --global merge.conflictstyle zdiff3 # 比 diff3 更紧凑的 3-way 冲突视图（git 自身能力，与 delta 配合更佳）
success "已配置 git 使用 delta 作为 diff/pager"

## zoxide：用 `z foo` 跳到匹配的目录，`zi` 走 fzf 交互式选
## direnv：在项目里 `echo 'export FOO=bar' > .envrc && direnv allow`
## yazi 文档：https://yazi-rs.github.io/

## 把必要的初始化行追加到 ~/.zshrc（append 是幂等的，重复跑无副作用）
## append_block 只在命令行缺失时连同注释一起写入，避免留下孤立注释
append_block "$ZSHRC" "# antidote 插件管理器" \
  'source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh' \
  'antidote load'
append_block "$ZSHRC" "# zoxide 目录跳转（必须在 antidote load 之后初始化）" \
  'eval "$(zoxide init zsh)"'
append_block "$ZSHRC" "# starship prompt" \
  'eval "$(starship init zsh)"'
append_block "$ZSHRC" "# direnv 目录级环境变量（钩子放最后，确保覆盖 starship 等设置的 PROMPT）" \
  'eval "$(direnv hook zsh)"'
echo ""
