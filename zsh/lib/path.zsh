# Setup $PATH
# Generally, the stuff in this file goes from least to most important,
# hence the `PATH=new_thing:$PATH` format


# Rust/Cargo binaries
if [ -d /Users/dnall/.cargo/bin ]; then
  PATH="/Users/dnall/.cargo/bin:${PATH}"
fi

# gem-installed stuff
if [ -d "/Users/dnall/.gem/ruby/2.0.0/bin" ]; then
  PATH="${PATH}:/Users/dnall/.gem/ruby/2.0.0/bin"
fi
if [ -d /usr/local/opt/ruby/bin ]; then
  PATH="/usr/local/opt/ruby/bin:${PATH}"
fi
PATH="${brew_path}/opt/ruby/bin:${PATH}"
# Add npm installed stuff to PATH
if [ -d "/Users/dnall/.npm-packages/bin" ]; then
  PATH="${PATH}:/Users/dnall/.npm-packages/bin"
fi

# /usr/local bin dirs
PATH="/usr/local/bin:${PATH}"
PATH="/usr/local/sbin:${PATH}"

## If MacOS, determine homebrew path and add to PATH
#if [[ $(uname) == 'Darwin' ]]; then
#  if which brew >/dev/null; then
#    export brew_binary=$(which brew)
#    export brew_path=$(dirname $brew_binary)
#  else
#    echo "ERROR: Homebrew not installed or not in $PATH"
#  fi
#fi

PATH="$HOME/homebrew/bin:${PATH}"
PATH="$HOME/homebrew/sbin:${PATH}"
PATH="$HOME/homebrew/opt:${PATH}"

# My ~/bin dir
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:${PATH}"
fi
