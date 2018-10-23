###############################################
## .zshrc                                    ##
###############################################


## History config
HISTFILE="$HOME/.zsh_history"
HISTSIZE="500000"
SAVEHIST="500000"
setopt EXTENDED_HISTORY         # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_IGNORE_DUPS         # Don't log duplicate entries
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_SPACE        # Dont record an entry starting with a space.
setopt HIST_VERIFY              # Show command with history expansion to user before running it

## Source other zsh config files
source "$HOME"/.dotfiles/zsh/lib/path.zsh
source "$HOME"/.dotfiles/zsh/lib/aliases.zsh
source "$HOME"/.dotfiles/zsh/lib/brew.zsh
source "$HOME"/.dotfiles/zsh/lib/clipboard.zsh
source "$HOME"/.dotfiles/zsh/lib/completions.zsh
source "$HOME"/.dotfiles/zsh/lib/fzf.zsh
if [ -f "HOME"/.dotfiles/zsh/lib/local.zsh ]; then
  source "$HOME"/.dotfiles/zsh/lib/local.zsh
fi

## Secrets!
if [ -f /Users/dnall/.dotfiles/secrets.txt ]
then
  source /Users/dnall/.dotfiles/secrets.txt
fi

## zplug
if [ -d "$HOME/homebrew/opt/zplug" ]; then
  export ZPLUG_HOME="$HOME/homebrew/opt/zplug"
elif [ -d /usr/local/opt/zplug ]; then
  export ZPLUG_HOME="/usr/local/opt/zplug"
fi

source $ZPLUG_HOME/init.zsh

fpath=( "$HOME/.dotfiles/zsh/zfunctions" $fpath )

## Plugins
#
## from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/thefuck", from:oh-my-zsh
## zsh-users
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
## other
zplug "supercrabtree/k"

# If any plugins aren't installed, install them
if ! zplug check --verbose; then
  printf "Install plugins? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Source plugins and add commands to PATH
zplug load

# Load prompt
autoload -U promptinit && promptinit
prompt devnall 

eval "$(ssh-agent -s)" &> /dev/null
ssh-add -K ~/.ssh/id_rsa &> /dev/null

autoload -U +X bashcompinit && bashcompinit
