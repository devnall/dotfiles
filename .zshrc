###############################################
## .zshrc                                    ##
###############################################

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"

if [ "$(uname -m)" = "arm64" ]; then
  : "${HOMEBREW_PREFIX:=/opt/homebrew}"
elif [ "$(uname -m)" = "x86_64" ]; then
  : "${HOMEBREW_PREFIX:=/usr/local}"
fi

if [ -z "$(echo $PATH | grep -o $HOMEBREW_PREFIX/bin)" ]; then
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"
fi

## History config
HISTFILE="${HOME}/.zsh_history"
HISTSIZE="500000"
SAVEHIST="500000"
setopt EXTENDED_HISTORY         # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_IGNORE_DUPS         # Don't log duplicate entries
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_SPACE        # Dont record an entry starting with a space.
setopt HIST_VERIFY              # Show command with history expansion to user before running it

## Directory navigation

DIRSTACKSIZE="12"               # Maximum number of entries in directory stack
setopt autopushd                # Make `cd` act like `pushd`
setopt pushdminus               # Swap meanings of `-` and `+` when specifying a directory in the stack
setopt pushdsilent              # Don't print the directory stack on every `cd`
setopt pushdtohome              # push to $HOME when no argument is given to `cd`
setopt pushdignoredups          # ignore duplicate entries in directory stack
setopt autocd                   # if a command isn't valid, but is a directory, cd to that directory

if command -v sheldon > /dev/null; then
  export SHELDON_CONFIG_DIR="$XDG_CONFIG_HOME/sheldon_zsh"
  export SHELDON_DATA_DIR="$XDG_DATA_HOME/sheldon_zsh"
  eval "$(sheldon source)"
fi

## Source other zsh config files
for zsh_file in ~/.dotfiles/zsh/lib/*.zsh; do
  source "$zsh_file"
done

export EDITOR="vim"

if command -v thefuck > /dev/null; then
  eval "$(thefuck --alias)"
fi

## Secrets!
if [ -f "${HOME}"/.dotfiles/secrets.txt ]
then
  source "${HOME}"/.dotfiles/secrets.txt
fi

# Config files that need to be loaded after zplug, for whatever reason
source "${HOME}"/.dotfiles/zsh/lib/aliases.zsh
source "${HOME}"/.dotfiles/zsh/lib/completions.zsh
if [ -f $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  echo "zsh-autosuggestions not installed or not getting sourced"
fi


# Set fpath (function path) and source function files
# TODO: I don't think explicitly sourcing the files should be necessary if 
# they're in fpath but without sourcing them explicitly, I had to execute a function
# twice before it would start working. Revisit/fix?
#fpath=( "${HOME}/.dotfiles/zsh/zfunctions" "$fpath" )
source "${HOME}"/.dotfiles/zsh/zfunctions/color_list
source "${HOME}"/.dotfiles/zsh/zfunctions/clipboard

# Load ssh-agent and add private key because OSX
eval "$(ssh-agent -s)" &> /dev/null
ssh-add -K ~/.ssh/id_rsa &> /dev/null

# Starship prompt
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
else
  autoload -U promptinit && promptinit
  prompt devnall
fi

if [[ -f "${HOME}/.dotfiles/zsh/lib/fzf.zsh" ]]; then
  source "${HOME}/.dotfiles/zsh/lib/fzf.zsh"
elif [[ -f "${HOME}/.fzf.zsh" ]]; then
  source "${HOME}/.fzf.zsh"
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $HOMEBREW_PREFIX/bin/terraform terraform
