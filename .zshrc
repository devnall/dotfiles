###############################################
## .zshrc                                    ##
###############################################


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

## Source other zsh config files
source "${HOME}"/.dotfiles/zsh/lib/path.zsh
source "${HOME}"/.dotfiles/zsh/lib/git.zsh
source "${HOME}"/.dotfiles/zsh/lib/brew.zsh
source "${HOME}"/.dotfiles/zsh/lib/fzf.zsh
source "${HOME}"/.dotfiles/zsh/lib/directory_nav.zsh
source "${HOME}"/.dotfiles/zsh/lib/history.zsh
if [ -f "${HOME}"/.dotfiles/zsh/lib/local.zsh ]; then
  source "${HOME}"/.dotfiles/zsh/lib/local.zsh
fi

export EDITOR="vim"

eval $(thefuck --alias)

## Secrets!
if [ -f "${HOME}"/.dotfiles/secrets.txt ]
then
  source "${HOME}"/.dotfiles/secrets.txt
fi

## zplug
if [ -d "${HOME}/homebrew/opt/zplug" ]; then
  export ZPLUG_HOME="${HOME}/homebrew/opt/zplug"
elif [ -d /usr/local/opt/zplug ]; then
  export ZPLUG_HOME="/usr/local/opt/zplug"
fi

source $ZPLUG_HOME/init.zsh

## Plugins
#
## from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
# This is making it take ~9sec for zsh to start :(
# Leaving it here to remind myself to never re-enable it
#zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/thefuck", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
## other
#zplug "supercrabtree/k"
zplug "devnall/k"
zplug "wfxr/forgit", defer:1
zplug "andrewferrier/fzf-z"
## zsh-users
zplug "zsh-users/zsh-history-substring-search"
#zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# If any plugins aren't installed, install them
if ! zplug check --verbose; then
  printf "Install plugins? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Source plugins and add commands to PATH
zplug load

# Config files that need to be loaded after zplug, for whatever reason
source "${HOME}"/.dotfiles/zsh/lib/aliases.zsh
source "${HOME}"/.dotfiles/zsh/lib/completions.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set fpath (function path) and source function files
# TODO: I don't think explicitly sourcing the files should be necessary if 
# they're in fpath but without sourcing them explicitly, I had to execute a function
# twice before it would start working. Revisit/fix?
fpath=( "${HOME}/.dotfiles/zsh/zfunctions" $fpath )
source "${HOME}"/.dotfiles/zsh/zfunctions/color_list
source "${HOME}"/.dotfiles/zsh/zfunctions/clipboard

# Load prompt
autoload -U promptinit && promptinit
prompt devnall 

# Load ssh-agent and add private key because OSX
eval "$(ssh-agent -s)" &> /dev/null
ssh-add -K ~/.ssh/id_rsa &> /dev/null

autoload -U +X bashcompinit && bashcompinit
