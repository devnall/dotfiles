# Set up Homebrew environment (PATH, MANPATH, INFOPATH, HOMEBREW_PREFIX, etc.)
# This runs in .zprofile so all login shells — interactive or not — get correct PATH ordering.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
