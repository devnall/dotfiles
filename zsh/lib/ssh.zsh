# SSH helper functions
# (use ssh-copy-id to copy public keys to remote hosts)

if [[ "$(uname)" == "Darwin" ]]; then
  # Use 1Password SSH agent for key management and commit signing.
  # ~/.1p-agent.sock is a no-space symlink to the actual socket at
  # ~/Library/Group Containers/... (path with a space breaks env file sourcing).
  export SSH_AUTH_SOCK="$HOME/.1p-agent.sock"
else
  # On Linux, use a persistent ssh-agent. Reuse an existing agent if the
  # socket is alive; otherwise start a new one and cache the env vars.
  _ssh_agent_env="$HOME/.ssh/agent.env"
  if [[ -S "${SSH_AUTH_SOCK:-}" ]] && ssh-add -l &>/dev/null; then
    : # agent already running and reachable
  else
    if [[ -f "$_ssh_agent_env" ]]; then
      source "$_ssh_agent_env" &>/dev/null
    fi
    if ! ssh-add -l &>/dev/null; then
      eval "$(ssh-agent -s)" &>/dev/null
      echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK; export SSH_AUTH_SOCK;" > "$_ssh_agent_env"
      echo "SSH_AGENT_PID=$SSH_AGENT_PID; export SSH_AGENT_PID;" >> "$_ssh_agent_env"
      chmod 600 "$_ssh_agent_env"
    fi
  fi
  unset _ssh_agent_env
fi
