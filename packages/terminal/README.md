## terminal

终端相关栈，目标是"轻量、现代、易迁移"。

- 终端：[ghostty](https://ghostty.org/)
- shell：zsh（macOS 默认，**不使用 oh-my-zsh**）
- 插件管理器：[antidote](https://getantidote.github.io/)
- 提示符：[starship](https://starship.rs/)（tokyo-night 风格预设）
- 字体：JetBrains Mono Nerd Font（ghostty 默认）
- 其它命令行工具：tree、tmux

## 配置文件（均通过 symlink 管理）

| 仓库内 | 软链到 |
|---|---|
| `packages/terminal/ghostty/config` | `~/.config/ghostty/config` |
| `packages/terminal/starship/starship.toml` | `~/.config/starship.toml` |
| `packages/terminal/zsh_plugins.txt` | `~/.zsh_plugins.txt` |

## ~/.zshrc 自动追加的行

`install.sh` 会用 `append`（幂等）把以下行加到 `~/.zshrc`：

```sh
# antidote 插件管理器
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load

# starship prompt
eval "$(starship init zsh)"
```

## 注意事项

- 安装完成后打开新终端即可生效
- 想换 starship 风格：`starship preset --list` 看官方预设，`starship preset gruvbox-rainbow -o ~/.config/starship.toml` 一键覆盖
- 想增减 antidote 插件：直接编辑 `packages/terminal/zsh_plugins.txt`（已 symlink），新开终端会自动重新 bundle
