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
export ZSH_THEME="devnall2"

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
plugins=(brew colored-man colorize docker docker-compose extract git gitfast history knife osx sublime terminalapp vagrant web-search zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

#
# Customize to your needs...
#

# Use zsh-completion.rb (from homebrew)
#fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(/Users/dnall/homebrew/bin/zsh-completions $fpath)

# Use vim and vim keybindings
export EDITOR="vim"
bindkey -v

# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

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

# If Homebrew zsh-syntax-highlighting is installed, use it
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f /Users/dnall/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /Users/dnall/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Add gem-installed executables to PATH
if [ -d /usr/local/opt/ruby/bin ]; then
  PATH="/usr/local/opt/ruby/bin:${PATH}"
fi

if [ -d /Users/dnall/homebrew/opt/ruby/bin ]; then
  PATH="/Users/dnall/homebrew/opt/ruby/bin:${PATH}"
fi

if [ -d /usr/local/share/zsh/help ]
then
  export HELPDIR=/usr/local/share/zsh/help
elif [ -d /Users/dnall/homebrew/share/zsh/help ]
then
  export HELPDIR=/Users/dnall/homebrew/share/zsh/help
else
  export HELPDIR=''
fi

# May be needed to access online help?
unalias run-help
autoload run-help
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

# Keep github from getting mad if I'm hammering it with homebrew
export HOMEBREW_GITHUB_API_TOKEN=789ee0a7cb754d3d6f872822af22545d18e67b11

# Trying out thefuck CLI tool
eval "$(thefuck --alias)"
