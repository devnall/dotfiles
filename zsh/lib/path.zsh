# Setup $PATH
# Generally, the stuff in this file goes from least to most important,
# hence the `PATH=new_thing:$PATH` format
# Note: Homebrew bin/sbin are handled in zshrc.zsh via $HOMEBREW_PREFIX.

# Rust/Cargo binaries
if [ -d "${HOME}/.cargo/bin" ]; then
  PATH="${HOME}/.cargo/bin:${PATH}"
fi

# Golang binaries
if [ -d "${HOME}/go/bin" ]; then
  PATH="${HOME}/go/bin:${PATH}"
fi

# gem-installed stuff — find the newest installed Ruby gem bin dir
for ruby_gem_bin in "${HOME}"/.gem/ruby/*/bin(N); do
  PATH="${PATH}:${ruby_gem_bin}"
done
unset ruby_gem_bin

# npm global packages
if [ -d "${HOME}/.npm-packages/bin" ]; then
  PATH="${PATH}:${HOME}/.npm-packages/bin"
fi

# My ~/bin dir
if [ -d "${HOME}/bin" ]; then
  PATH="${HOME}/bin:${PATH}"
fi

# ~/.local/bin (e.g. Claude Code, pip --user installs)
if [[ -d "${HOME}/.local/bin" ]]; then
  PATH="${HOME}/.local/bin:$PATH"
fi
