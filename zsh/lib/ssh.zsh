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
  # `ssh-add -l` exits 1 for a reachable agent with no keys and 2 when no agent
  # is reachable; only 2 means "start one" (else every shell spawns an agent).
  _ssh_agent_env="$HOME/.ssh/agent.env"
  ssh-add -l &>/dev/null
  if (( $? == 2 )); then
    [[ -f "$_ssh_agent_env" ]] && source "$_ssh_agent_env" &>/dev/null
    ssh-add -l &>/dev/null
    if (( $? == 2 )); then
      eval "$(ssh-agent -s)" &>/dev/null
      mkdir -p -m 700 "${_ssh_agent_env:h}"
      echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK; export SSH_AUTH_SOCK;" > "$_ssh_agent_env"
      echo "SSH_AGENT_PID=$SSH_AGENT_PID; export SSH_AGENT_PID;" >> "$_ssh_agent_env"
      chmod 600 "$_ssh_agent_env"
    fi
  fi
  unset _ssh_agent_env
fi
