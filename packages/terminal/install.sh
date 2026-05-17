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

## 树形目录
brew_install tree

## 安装 tmux
brew_install tmux

## 字体
brew_cask_install font-fira-code-nerd-font
brew_cask_install font-fira-mono-nerd-font
brew_cask_install font-jetbrains-mono-nerd-font

## ghostty 终端
brew_cask_install ghostty
mkdir -p "$HOME/.config/ghostty"
link_file "$PWD/packages/terminal/ghostty/config" "$HOME/.config/ghostty/config"

## starship prompt
brew_install starship
mkdir -p "$HOME/.config"
link_file "$PWD/packages/terminal/starship/starship.toml" "$HOME/.config/starship.toml"

## antidote 插件管理器（替代 oh-my-zsh，更轻量）
## 文档：https://getantidote.github.io/
brew_install antidote
link_file "$PWD/packages/terminal/zsh_plugins.txt" "$HOME/.zsh_plugins.txt"

## 现代 CLI - 经典 Unix 工具的替代品（详细说明见 README "命令行工具速查"）
brew_install bat         # cat 替代：语法高亮 + 行号 + git diff
brew_install eza         # ls 替代：彩色 + git 状态 + tree 模式
brew_install fzf         # 模糊查找（zoxide/yazi/zsh 历史搜索都依赖它）
brew_install bottom      # top 替代：跨平台，命令名 btm
brew_install mactop      # macOS 专用 top：CPU/GPU/能耗
brew_install dust        # du 替代：树形可视化磁盘占用
brew_install duf         # df 替代：彩色磁盘容量表
brew_install procs       # ps 替代
brew_install sd          # sed 替代：语法更直观

## 终端 TUI 应用
brew_install lazygit     # Git TUI，键盘流操作
brew_install jless       # JSON viewer TUI（搭配 jq 用）
brew_install glow        # 终端 markdown 渲染器
brew_install gum         # Charm 出的 shell 脚本 UI 组件

## 其他终端工具增强
brew_install delta       # git diff 美化 pager（用前需要配置 ~/.gitconfig，详见 README）
brew_install xh          # curl/httpie 替代，写 API 测试快
brew_install tokei       # 代码统计

## zoxide 智能目录跳转（rupa/z 的现代替代品）
## 用 `z foo` 跳到匹配的目录，`zi` 走 fzf 交互式选
brew_install zoxide

## yazi 文件管理 TUI
## 文档：https://yazi-rs.github.io/
## 预览依赖（ffmpeg/imagemagick/poppler/sevenzip）在主 install.sh 里装
brew_install yazi

## 把必要的初始化行追加到 ~/.zshrc（append 是幂等的，重复跑无副作用）
append "# antidote 插件管理器" "$ZSHRC"
append 'source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh' "$ZSHRC"
append 'antidote load' "$ZSHRC"
append "" "$ZSHRC"
append "# zoxide 目录跳转（必须在 antidote load 之后初始化）" "$ZSHRC"
append 'eval "$(zoxide init zsh)"' "$ZSHRC"
append "" "$ZSHRC"
append "# starship prompt" "$ZSHRC"
append 'eval "$(starship init zsh)"' "$ZSHRC"
echo ""
