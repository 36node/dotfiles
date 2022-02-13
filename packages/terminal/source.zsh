## zsh-autosuggestions
source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

## zsh-syntax-highlighting
source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## autojump
[ -f ${HOMEBREW_PREFIX}/etc/profile.d/autojump.sh ] && . ${HOMEBREW_PREFIX}/etc/profile.d/autojump.sh

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

## proxy icon for powerline
function proxy_status() {
  if [ -z $HTTP_PROXY ];then
    echo ""
  else
    echo "✈"
  fi
}

###############################################################################
# some alias
###############################################################################
alias k="kubectl"