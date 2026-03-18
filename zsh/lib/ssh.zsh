# SSH helper functions
# (use ssh-copy-id to copy public keys to remote hosts)

# Use 1Password SSH agent for key management and commit signing.
# ~/.1p-agent.sock is a no-space symlink to the actual socket at
# ~/Library/Group Containers/... (path with a space breaks env file sourcing).
export SSH_AUTH_SOCK="$HOME/.1p-agent.sock"
