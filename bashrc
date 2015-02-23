export EDITOR=vim

parse_git_branch() {
  ref=$(git symbolic-ref HEAD -q 2>/dev/null)
  st=$?
  if [ $st -eq 1 ]; then
    echo ":~~detached~~"
  elif [ $st -eq 0 ]; then
    echo ":${ref#refs/heads/}"
  fi  
}

nonprintable() {
  # this is necessary for control characters that don't ouptut text to avoid
  # problems with text wrapping
  echo '\['$1'\]'
}
color() {
  # $1 is color intensity (0 for normal or 1 for bright/bold)
  # $2 should be 30 for black, 31 for red, 32 for green, 33 for yellow,
  #              34 for blue, 35 for magenta, 36 for cyan, or 37 for white
  # $3 is the text to color
  echo "$(nonprintable '\e['$1';'$2'm')$3$(nonprintable '\e[m')"
}

# [\$(date +%H:%M:%S)].
# \u@\h:
PS1="${debian_chroot:+($debian_chroot)}\w\$(parse_git_branch)\$ "
XTERM_TITLE="\w\$(parse_git_branch)"
PS1="$(color 0 ${PS1_COLOR:-32} "$PS1")" # make prompt green
PS1="$(nonprintable '\e]0;'$XTERM_TITLE'\a')$PS1" # set window title
