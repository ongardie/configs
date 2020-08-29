# This sets up environment variables and aliases that should be avaliable
# everywhere in both login & non-login and both interactive & non-iteractive
# shells. It should be compatible with various shells (dash, bash, zsh). You may
# want to point ~/.zshenv, ~/.bash_profile, and ~/.xsession at this.

# Add directories to $PATH. These guards are here to avoid adding redundant
# paths, even if this file is sourced multiple times.
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac
case ":$PATH:" in
  *":/sbin:"*) ;;
  *) export PATH="$PATH:/sbin" ;;
esac
case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;
  *) export PATH="$PATH:$HOME/.cargo/bin" ;;
esac

export BROWSER="$HOME/bin/firefox"
export LESSSECURE='1'
export LC_COLLATE='C'
export PAGER='less --chop-long-lines --jump-target=5 --no-init --RAW-CONTROL-CHARS --quit-if-one-screen --shift=.2'
export TMPDIR="$HOME/tmp"
export XTERM='xfce4-terminal'

alias df='df -h'
alias diff='diff --new-file --recursive --unified'
alias gvim='gvim -p'
if [ -n "$BASH_VERSION" ]; then
  alias run-help='help'
elif [ -n "$ZSH_VERSION" ]; then
  alias help='run-help'
fi
alias iotop='iotop --only'
alias less=$PAGER
alias ls='ls --almost-all --color=always --group-directories-first --human-readable --time-style=long-iso'
alias mplayer='mplayer -af scaletempo'
alias ps='ps uxf'
alias py='ipython3 --no-banner --no-confirm-exit'
alias sl='sl -e'
alias tree='tree -aCh'
alias vim='vim -p'
alias watch='watch --interval=1'
