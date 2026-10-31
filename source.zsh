#!/bin/zsh
#
# source everything here

# 当前 script 所在目录（%x 是正在被 source 的文件，:A 解析软链得到真实路径）
DOTFILES_DIR="${${(%):-%x}:A:h}"
HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

## 加载共享环境变量 .env（跨机器共享，通过 vault 同步，默认 iCloud Drive）
## 再加载本机覆盖 .env.local（机器特定，不进 git、不进 vault），同名变量会覆盖前者
. "$DOTFILES_DIR/lib/env.sh"
load_env "$DOTFILES_DIR/.env"
load_env "$DOTFILES_DIR/.env.local"
unset -f load_env

## 需要 glob 的部分放进 emulate -L zsh 的函数里跑，不受用户 setopt
## （shglob / nobareglobqual / noglob / ksharrays 等）影响；结果写到全局变量
##   - gem 的 bin 目录直接按 glob 找，避免每次开 shell 都跑一遍 `gem environment`
##   - packages/*/source.zsh 列表（真正 source 放在函数外，免得包里的 typeset 变成局部）
_dotfiles_globs() {
  emulate -L zsh
  setopt nullglob numericglobsort
  local -a gem_bins
  gem_bins=( "$HOMEBREW_PREFIX"/lib/ruby/gems/*/bin )
  _dotfiles_gem_bin=${gem_bins[-1]}
  _dotfiles_packages=( "$DOTFILES_DIR"/packages/*/source.zsh )
}
_dotfiles_globs
unfunction _dotfiles_globs

## ruby
if [ -d "${HOMEBREW_PREFIX}/opt/ruby/bin" ]; then
  export PATH=${HOMEBREW_PREFIX}/opt/ruby/bin:$PATH
  [ -n "$_dotfiles_gem_bin" ] && export PATH=$_dotfiles_gem_bin:$PATH
fi

###############################################################################
# packages
###############################################################################

for _dotfiles_package in "${_dotfiles_packages[@]}"; do
  . "$_dotfiles_package"
done
unset _dotfiles_gem_bin _dotfiles_packages _dotfiles_package
