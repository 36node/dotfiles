## 之后在 shell 里 pyenv install 也走国内镜像（见同目录 mirror.sh）
. "$DOTFILES_DIR/packages/python/mirror.sh"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi