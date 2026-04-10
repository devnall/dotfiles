# Remote-full shell config — sourced when ~/.remote-full marker exists
# For Linux/remote servers with Homebrew/LinuxBrew and full tool suite installed

export STARSHIP_CONFIG=~/.config/starship-remote.toml

# Disable git commit signing by default on remote machines (no 1Password agent).
# To enable signing, set user.signingkey in config/git/.gitconfig-user and
# add your private key to the ssh-agent (ssh-add ~/.ssh/id_ed25519), then
# override this with: git config --global commit.gpgsign true
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0="commit.gpgsign"
export GIT_CONFIG_VALUE_0="false"
