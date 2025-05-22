# Setup $PATH
# Generally, the stuff in this file goes from least to most important,
# hence the `PATH=new_thing:$PATH` format


# Rust/Cargo binaries
if [ -d "${HOME}"/.cargo/bin ]; then
  PATH="${HOME}/.cargo/bin:${PATH}"
fi

# Golang binaries
if [ -d "${HOME}"/go/bin ]; then
  PATH="${HOME}/go/bin:${PATH}"
fi

# gem-installed stuff
# this should probably be a case statement to handle multiple installed versions?
if [ -d "${HOME}/.gem/ruby/2.0.0/bin" ]; then
  PATH="${PATH}:${HOME}/.gem/ruby/2.0.0/bin"
elif [ -d "${HOME}/.gem/ruby/2.3.0/bin" ]; then
  PATH="${PATH}:${HOME}/.gem/ruby/2.3.0/bin"
elif [ -d "${HOME}/.gem/ruby/2.5.0/bin" ]; then
  PATH="${PATH}:${HOME}/.gem/ruby/2.5.0/bin"
elif [ -d "${HOME}/.gem/ruby/2.7.0/bin" ]; then
  PATH="${PATH}:${HOME}/.gem/ruby/2.7.0/bin"
elif [ -d "${HOME}/.gem/ruby/3.0.0/bin" ]; then
  PATH="/${PATH}:${HOME}/.gem/ruby/3.0.0/bin"
elif [ -d /usr/local/opt/ruby/bin ]; then
  PATH="/usr/local/opt/ruby/bin:${PATH}"
fi
PATH="${brew_path}/opt/ruby/bin:${PATH}"
# Add npm installed stuff to PATH
if [ -d "${HOME}/.npm-packages/bin" ]; then
  PATH="${PATH}:${HOME}/.npm-packages/bin"
fi
# Add pip installed stuff to PATH (Python3)
if [ -d "${HOME}/Library/Python/3.7/bin" ]; then
  PATH="${PATH}:${HOME}/Library/Python/3.7/bin"
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

if [ -d "${HOME}/homebrew/bin" ]; then
  PATH="${HOME}/homebrew/bin:${PATH}"
fi
if [ -d "/opt/homebrew/bin" ]; then
  PATH="/opt/homebrew/bin:${PATH}"
fi
if [ -d "${HOME}/homebrew/sbin" ]; then
  PATH="${HOME}/homebrew/sbin:${PATH}"
fi
if [ -d "/opt/homebrew/sbin" ]; then
  PATH="/opt/homebrew/sbin:${PATH}"
fi
if [ -d "${HOME}/homebrew/opt" ]; then
  PATH="${HOME}/homebrew/opt:${PATH}"
fi
if [ -d "/opt/homebrew/opt" ]; then
  PATH="/opt/homebrew/opt:${PATH}"
fi

# My ~/bin dir
if [ -d "${HOME}/bin" ]; then
  PATH="${HOME}/bin:${PATH}"
fi
