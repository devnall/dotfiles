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

# gem-installed stuff — find the newest installed Ruby gem bin dir
for ruby_gem_bin in "${HOME}"/.gem/ruby/*/bin(N); do
  PATH="${PATH}:${ruby_gem_bin}"
done
unset ruby_gem_bin
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


# For Claude Code
if [[ -d "${HOME}/.local/bin" ]]; then
  PATH="${HOME}/.local/bin:$PATH"
fi
