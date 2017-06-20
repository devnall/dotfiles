###############################################
## .zshrc                                    ##
###############################################

## Use vim and vim keybindings
#export EDITOR="vim"
#bindkey -v
#
## vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

## Set my path
# TODO: Move this into zsh/lib/path.zsh
# TODO: Build in some OS-specific logic
#
# Add my ~/bin dir to PATH
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:${PATH}"
fi
# Add homebrew dirs to PATH
if [ -d /usr/local/bin ]; then
  PATH="/usr/local/bin:${PATH}"
fi
if [ -d /Users/dnall/homebrew/bin ]; then
  PATH="/Users/dnall/homebrew/bin:${PATH}"
fi
if [ -d /usr/local/sbin ]; then
  PATH="/usr/local/sbin:${PATH}"
fi
if [ -d /Users/dnall/homebrew/sbin ]; then
  PATH="/Users/dnall/homebrew/sbin:${PATH}"
fi
# Hombrew Cask in userspace
export HOMEBREW_CASK_OPTS="--appdir=/Users/dnall/Applications"
# Add gem installed stuff to PATH
if [ -d "/Users/dnall/.gem/ruby/2.0.0/bin" ]; then
  PATH="${PATH}:/Users/dnall/.gem/ruby/2.0.0/bin"
fi
if [ -d /usr/local/opt/ruby/bin ]; then
  PATH="/usr/local/opt/ruby/bin:${PATH}"
fi
if [ -d /Users/dnall/homebrew/opt/ruby/bin ]; then
  PATH="/Users/dnall/homebrew/opt/ruby/bin:${PATH}"
fi
# Add zsh-completions to fpath
if [ -d /Users/dnall/homebrew/share/zsh-completions ]; then
  fpath=(/Users/dnall/homebrew/share/zsh-completions $fpath)
fi
# Use GPG2.1 instead of 2.0
if [ -d /Users/dnall/homebrew/Cellar/gnupg@2.1/2.1.19/bin ]; then
  PATH="/Users/dnall/homebrew/Cellar/gnupg@2.1/2.1.19/bin:${PATH}"
fi

## History config
HISTFILE="$HOME/.zsh_history"
HISTSIZE="500000"
SAVEHIST="500000"
setopt EXTENDED_HISTORY   # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.

## Set helpdir
if [ -d /usr/local/share/zsh/help ]
then
  export HELPDIR=/usr/local/share/zsh/help
elif [ -d /Users/dnall/homebrew/share/zsh/help ]
then
  export HELPDIR=/Users/dnall/homebrew/share/zsh/help
else
  export HELPDIR=''
fi
## May be needed to access online help?
autoload run-help

# Secrets!
if [ -f /Users/dnall/.dotfiles/secrets.txt ]
then
  source /Users/dnall/.dotfiles/secrets.txt
fi

# TODO: Move this somewhere better if I like it
# ccat - colorized cat
alias cat=ccat

#
## zplug
fpath=( "$HOME/.dotfiles/zsh/zfunctions" $fpath )

if [ -f /Users/dnall/homebrew/opt/zplug ]
then
  export ZPLUG_HOME=/Users/dnall/homebrew/opt/zplug
elif [ -f /usr/local/opt/zplug ]
then
  export ZPLUG_HOME=/usr/local/opt/zplug
fi
source $ZPLUG_HOME/init.zsh

#
## Plugins
#
## from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/thefuck", from:oh-my-zsh
## zsh-users
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
# Use my autosuggestion fork until PR150 or Issue126
# get merged upstream to fix segfault
#zplug "zsh-users/zsh-autosuggestions"
zplug "devnall/zsh-autosuggestions"
## other
zplug "djui/alias-tips"
zplug "supercrabtree/k"
zplug "~/.dotfiles/zsh/zfunctions/prompt_devnall2_setup", from:local, as:theme
# If any plugins aren't installed, install them
if ! zplug check --verbose; then
  printf "Install plugins? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Source plugins and add commands to PATH
zplug load

source ~/.dotfiles/zsh/lib/*.zsh

# pure promt testing
autoload -U promptinit && promptinit
prompt devnall2 

#ssh-add -K ~/.ssh/id_rsa
eval "$(ssh-agent -s)" &> /dev/null
#ssh-add -A
