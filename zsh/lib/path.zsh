# Setup $PATH
# Generally, the stuff in this file goes from least to most important,
# hence the `PATH=new_thing:$PATH` format


# Rust/Cargo binaries
if [ -d /Users/drew/.cargo/bin ]; then
  PATH="/Users/drew/.cargo/bin:${PATH}"
fi

# gem-installed stuff
if [ -d "/Users/drew/.gem/ruby/2.0.0/bin" ]; then
  PATH="${PATH}:/Users/drew/.gem/ruby/2.0.0/bin"
elif [ -d "/Users/drew/.gem/ruby/2.3.0/bin" ]; then
  PATH="${PATH}:/Users/drew/.gem/ruby/2.0.0/bin"
elif [ -d "/Users/drew/.gem/ruby/2.5.0/bin" ]; then
  PATH="${PATH}:/Users/drew/.gem/ruby/2.0.0/bin"
elif [ -d /usr/local/opt/ruby/bin ]; then
  PATH="/usr/local/opt/ruby/bin:${PATH}"
fi
PATH="${brew_path}/opt/ruby/bin:${PATH}"
# Add npm installed stuff to PATH
if [ -d "/Users/drew/.npm-packages/bin" ]; then
  PATH="${PATH}:/Users/drew/.npm-packages/bin"
fi
# Add pip installed stuff to PATH (Python3)
if [ -d "/Users/drew/Library/Python/3.7/bin" ]; then
  PATH="${PATH}:/Users/drew/Library/Python/3.7/bin"
fi

# /usr/local bin dirs
PATH="/usr/local/bin:${PATH}"
PATH="/usr/local/sbin:${PATH}"

# If homebrew curl is installed, use it instead of MacOS default curl
if [ -d "/usr/local/opt/curl/bin" ]; then
  PATH="${PATH}:/usr/local/opt/curl/bin"
fi

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
