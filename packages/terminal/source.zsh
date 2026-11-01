# 不用 oh-my-zsh，ll / la 这类常用别名得自己定义
# 有 eza 就用 eza（彩色 + 图标 + git 状态），没装时退回系统 ls
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons=auto"
  alias ll="eza -l --icons=auto --git --group-directories-first"
  alias la="eza -la --icons=auto --git --group-directories-first"
  alias lt="eza --tree --level=2 --icons=auto"
else
  alias ll="ls -lhG"
  alias la="ls -lAhG"
fi
