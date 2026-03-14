# Remote/server shell config — sourced when ~/.remote marker exists
# Goal: muscle-memory-friendly, zero external dependencies required

# System ls fallback (no eza on most servers)
if ! command -v eza > /dev/null; then
  alias l='ls -lahF'
  alias ll='ls -lahF'
  alias lt='ls -lahFt'
fi

# bat fallback to cat if not available
if ! command -v bat > /dev/null; then
  alias batp='cat'
fi

# fzf key bindings if available (can be installed as a single binary on Linux)
if command -v fzf > /dev/null; then
  [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# Simple prompt fallback if starship isn't installed
# (starship can be installed on Linux as a single curl | sh)
if ! command -v starship > /dev/null; then
  autoload -U promptinit && promptinit 2>/dev/null || true
fi
