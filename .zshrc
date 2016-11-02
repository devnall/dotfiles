###############################################
## .zshrc                                     #
## zsh configuration file                     #
## Maintainer: Drew Nall <drewnall@gmail.com> #
## Last updated: Oct 23, 2016                 #
###############################################

## Use vim and vim keybindings
#export EDITOR="vim"
#bindkey -v
#
## vi style incremental search
#bindkey '^R' history-incremental-search-backward
#bindkey '^S' history-incremental-search-forward
#bindkey '^P' history-search-backward
#bindkey '^N' history-search-forward
#
## Add my ~/bin dir to PATH
#if [ -d "$HOME/bin" ]; then
#  PATH="$HOME/bin:${PATH}"
#fi

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

## Add gem installed stuff to PATH
#if [ -d "/Users/dnall/.gem/ruby/2.0.0/bin" ]; then
#  PATH="${PATH}:/Users/dnall/.gem/ruby/2.0.0/bin"
#fi
#
## If Homebrew zsh-syntax-highlighting is installed, use it
#if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
#  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#fi
#
#if [ -f /Users/dnall/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
#  source /Users/dnall/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#fi
#
## Add gem-installed executables to PATH
#if [ -d /usr/local/opt/ruby/bin ]; then
#  PATH="/usr/local/opt/ruby/bin:${PATH}"
#fi
#
#if [ -d /Users/dnall/homebrew/opt/ruby/bin ]; then
#  PATH="/Users/dnall/homebrew/opt/ruby/bin:${PATH}"
#fi
#
#if [ -d /usr/local/share/zsh/help ]
#then
#  export HELPDIR=/usr/local/share/zsh/help
#elif [ -d /Users/dnall/homebrew/share/zsh/help ]
#then
#  export HELPDIR=/Users/dnall/homebrew/share/zsh/help
#else
#  export HELPDIR=''
#fi
#
## May be needed to access online help?
#unalias run-help
#autoload run-help
#export PATH="$HOME/.rbenv/bin:$PATH"
#if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

# Trying out thefuck CLI tool
#eval "$(thefuck --alias)"

# Secrets!
if [ -f /Users/dnall/.dotfiles/secrets.txt ]
then
  source /Users/dnall/.dotfiles/secrets.txt
fi

# Kubectl completions
# TODO: Move this somewhere else - oh-my-zsh plugin maybe?
#source <(kubectl completion zsh)

# TODO: Move this somewhere better if I like it
# ccat - colorized cat
#alias cat=ccat

## zplug
#

fpath=( "$HOME/.dotfiles/zsh/zfunctions" $fpath )

source ~/homebrew/opt/zplug/init.zsh

# Plugins
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh

# If any plugins aren't installed, install them
if ! zplug check --verbose; then
  printf "Install plugins? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Source plugins and add commands to PATH
zplug load

#source ~/.dotfiles/zsh/lib/*.zsh

# pure promt testing
autoload -U promptinit && promptinit
prompt devnall2 
