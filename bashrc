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

prompt_command() {
  status=$?
  git=$(parse_git_branch)
  visible="\w$git\$ "
  if [ $status -eq 0 ]; then
    colored=$(color 0 32 "$visible")
  else
    warning=$(color 0 31 "Command exited with status $status")
    colored=$warning'\n'$(color 0 31 "$visible")
  fi
  xterm_title=$(nonprintable '\e]0;\w'$git'\a')
  PS1="$xterm_title$colored"
}

PROMPT_COMMAND='prompt_command'
