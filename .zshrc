###############################################
## .zshrc                                     #
## zsh configuration file                     #
## Maintainer: Drew Nall <drewnall@gmail.com> #
## Last updated: July 27, 2015                #
###############################################


# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="devnall"
#ZSH_THEME="clean"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many days you would like to wait before auto-updates occur?
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew colored-man colorize extract git gitfast history osx sublime terminalapp vi-mode web-search zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#
# Customize to your needs...
#

# Use zsh-completion.rb (from homebrew)
fpath=(/usr/local/share/zsh-completions $fpath)

# Use vim and vim keybindings
export EDITOR="vim"
bindkey -v

# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Add my ~/bin dir to PATH
if [ -d ~/bin ]; then
  PATH="~/bin:${PATH}"
fi

# Add homebrew dirs to PATH
if [ -d /usr/local/bin ]; then
  PATH="/usr/local/bin:${PATH}"
fi

if [ -d /usr/local/sbin ]; then
  PATH="/usr/local/sbin:${PATH}"
fi

# If Homebrew zsh-syntax-highlighting is installed, use it
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Add gem-installed executables to PATH
if [ -d /usr/local/opt/ruby/bin ]; then
  PATH="/usr/local/opt/ruby/bin:${PATH}"
fi

# May be needed to access online help?
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles
