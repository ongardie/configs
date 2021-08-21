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
  *":/usr/sbin:"*) ;;
  *) export PATH="$PATH:/usr/sbin" ;;
esac
case ":$PATH:" in
  *":$HOME/configs/bin:"*) ;;
  *) export PATH="$PATH:$HOME/configs/bin" ;;
esac
case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;
  *) export PATH="$PATH:$HOME/.cargo/bin" ;;
esac

export BROWSER='firefox'
export LESSSECURE='1'
export LC_COLLATE='C'
export PAGER='less --chop-long-lines --jump-target=5 --ignore-case --no-init --RAW-CONTROL-CHARS --quit-if-one-screen --shift=.2'
export TMPDIR="$HOME/tmp"
export XTERM='xfce4-terminal'

if command -v batcat >/dev/null && ! command -v bat >/dev/null; then
  alias bat='batcat'
fi
alias cp='cp --interactive'
alias df='df --human-readable'
alias diff='diff --new-file --recursive --unified'
alias du='du --human-readable'
if command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
  alias fd='fdfind'
fi
alias feh='feh --scale-down'
alias gitk='gitk --all'
alias gpg='gpg --no-symkey-cache'
alias gvim='gvim -p'
if [ -n "$ZSH_VERSION" ]; then
  alias help='run-help'
elif [ -n "$BASH_VERSION" ]; then
  alias run-help='help'
fi
alias hexdump='hexdump -C'
alias iotop='iotop --only'
alias jq='jq --color-output'
alias less=$PAGER
alias ls='ls --almost-all --color=always --group-directories-first --human-readable --time-style=long-iso'
alias mplayer='mplayer -af scaletempo'
alias mv='mv --interactive'
if command -v xdg-open >/dev/null && ! command -v open >/dev/null; then
  alias open='xdg-open'
fi
alias ps='ps uxf'
alias py='ipython3 --no-banner --no-confirm-exit'
alias sl='sl -e'
alias timestamp='date --utc "+%Y-%m-%dT%H:%M:%SZ"'
alias tree='tree -aCh'
alias vim='vim -p'
alias watch='watch --interval=1'
alias xev='xev -event keyboard -event button'

# The 'free' command uses a lot of extra whitespace by default. This
# function reformats the output for narrower terminals.
#
# Note: One downside of using `column` is that it can't right-align the
# columns. Anyway, normal `free --human` also screws this up a little when
# the units aren't the same width.
free() {
  {
    echo -n .
    command free --human --wide "$@"
  } | column -t
}



#if find -s /dev/null >/dev/null 2>&1; then
#  alias find='find -s'
#fi
