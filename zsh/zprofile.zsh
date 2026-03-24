# Set up Homebrew environment (PATH, MANPATH, INFOPATH, HOMEBREW_PREFIX, etc.)
# This runs in .zprofile so all login shells — interactive or not — get correct PATH ordering.
if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$(uname -m)" = "x86_64" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
