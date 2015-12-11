#!/bin/sh
#
# This should help get tmux buffer copy/paste working better on OSX
# See https://robots.thoughtbot.com/how-to-copy-and-paste-with-tmux-on-mac-os-x for more info

while true; do
  if test -n "`tmux showb 2> /dev/null`"; then
    tmux saveb -|pbcopy && tmux deleteb
  fi
  sleep 0.5
done
