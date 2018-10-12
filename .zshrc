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

## If MacOS, determine homebrew path
if [[ `uname` == 'Darwin' ]]; then
  if [ -d /usr/local/bin/homebrew ]; then
    export brew_path="/usr/local/bin/homebrew"
  elif [ -d /Users/dnall/homebrew ]; then
    export brew_path="/Users/dnall/homebrew"
  else
    echo "ERROR: Unable to locate homebrew directory"
  fi
fi

## Set my path
# TODO: Move this into zsh/lib/path.zsh
# TODO: Build in some OS-specific logic
#
# Add my ~/bin dir to PATH
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:${PATH}"
fi
# Add more bin dirs to PATH
PATH="/usr/local/bin:${PATH}"
PATH="/usr/local/sbin:${PATH}"
# Add homebrew dirs to PATH
PATH="${brew_path}/bin:${PATH}"
PATH="${brew_path}/sbin:${PATH}"
# Homebrew Cask in userspace
export HOMEBREW_CASK_OPTS="--appdir=/Users/dnall/Applications"
# Add gem installed stuff to PATH
if [ -d "/Users/dnall/.gem/ruby/2.0.0/bin" ]; then
  PATH="${PATH}:/Users/dnall/.gem/ruby/2.0.0/bin"
fi
if [ -d /usr/local/opt/ruby/bin ]; then
  PATH="/usr/local/opt/ruby/bin:${PATH}"
fi
PATH="${brew_path}/opt/ruby/bin:${PATH}"
# Add npm installed stuff to PATH
if [ -d "/Users/dnall/.npm-packages/bin" ]; then
  PATH="${PATH}:/Users/dnall/.npm-packages/bin"
fi
# Add zsh-completions to fpath
fpath=(${brew_path}/share/zsh-completions $fpath)
# Rust/Cargo binaries
if [ -d /Users/dnall/.cargo/bin ]; then
  PATH="/Users/dnall/.cargo/bin:${PATH}"
fi
if [ -d /Users/dnall/homebrew/bin ]; then
  PATH="/Users/dnall/homebrew/bin:${PATH}"
fi
if [ -d /Users/dnall/homebrew/sbin ]; then
  PATH="/Users/dnall/homebrew/sbin:${PATH}"
fi

## History config
HISTFILE="$HOME/.zsh_history"
HISTSIZE="500000"
SAVEHIST="500000"
setopt EXTENDED_HISTORY         # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_SPACE        # Dont record an entry starting with a space.

# brew installing node installs an old version of npm
# to install new version, do the following:
# `ls /usr/local/lib/node_modules` and make a note of any packages to reinstall
# `rm -rf /usr/local/lib/node_modules`
# `brew uninstall node`
# `brew install node --without-npm
# `echo prefix=~/.npm-packages >> ~/.npmrc`
# `curl -L https://www.npmjs.com/install.sh | sh`
# Add .npm-packages to PATH:
export NODE_PATH="$HOME/homebrew/lib/node_modules"
export PATH="$HOME/.npm-packages/bin:$PATH"
# Reinstall any packages deleted in step 2


# Secrets!
if [ -f /Users/dnall/.dotfiles/secrets.txt ]
then
  source /Users/dnall/.dotfiles/secrets.txt
fi

#
## zplug
fpath=( "$HOME/.dotfiles/zsh/zfunctions" $fpath )

if [ -d ${brew_path}/opt/zplug ]
then
  export ZPLUG_HOME="${brew_path}/opt/zplug"
elif [ -d /usr/local/opt/zplug ]
then
  export ZPLUG_HOME="/usr/local/opt/zplug"
fi
source $ZPLUG_HOME/init.zsh

fpath=( "$HOME/.dotfiles/zsh/zfunctions" $fpath )

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
#zplug "plugins/kubectl", from:oh-my-zsh
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

source "$HOME"/.dotfiles/zsh/lib/aliases.zsh
source "$HOME"/.dotfiles/zsh/lib/brew.zsh
source "$HOME"/.dotfiles/zsh/lib/clipboard.zsh
source "$HOME"/.dotfiles/zsh/lib/completions.zsh
source "$HOME"/.dotfiles/zsh/lib/keybinds.zsh
source "$HOME"/.dotfiles/zsh/lib/fzf.zsh

# Load prompt
autoload -U promptinit && promptinit
prompt devnall 

eval "$(ssh-agent -s)" &> /dev/null
ssh-add -K ~/.ssh/id_rsa &> /dev/null

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /Users/dnall/homebrew/Cellar/terraform/0.11.8/bin/terraform terraform
