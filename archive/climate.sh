#!/bin/bash

# Function that looks to see if a file already exists in ~
# If it does, diff it against the canonical .dotfile version.
## If diff matches, done.
## If diff doesn't match, backup local version, delete it, create a symlink to the .dotfile version, and log it
# If it doesn't, create a symlink to the .dotfile version
# If it's a link it should be pointing to .dotfile version, otherwise error



# Call above function for:
# .gitconfig
# Bash stuff
# Zsh stuff
# vim stuff?
# tmux stuff
# screen stuff
