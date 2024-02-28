#!/bin/sh

set -e

if [ $# -eq 1 ]; then
  SIZE=$1
  for dir in /etc/X11/notion /etc/notion /usr/local/etc/notion; do
    INPUT="$dir/look_newviolet_hidpi.lua"
    if [ -f "$INPUT" ]; then
      break
    fi
  done
elif [ $# -eq 2 ]; then
  SIZE=$1
  INPUT=$2
else
  echo "Usage: $0 FONTSIZE [LOOK_FILE] > ~/.notion/look.lua" >&2
  exit 1
fi

that=This
echo "-- $that file was generated from $INPUT using:"
echo "-- $(realpath -s "$0")" "$@"
sed -E "s/^( *font = .*)size=[0-9]+/\1size=$SIZE/" < "$INPUT"
