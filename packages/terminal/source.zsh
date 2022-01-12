## zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

## zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

## powerline
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true ## please use `p10k configure` manually
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme

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