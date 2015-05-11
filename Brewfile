#############################################
# Brewfile                                  #
# Install homebrew packages                 #
# Maintainer: Drew Nall <drewnall@gmail.com #
# Last Updated: May 10, 2015                #
#############################################

# Usage:
# See http://robots.thoughtbot.com/brewfile-a-gemfile-but-for-homebrew
# To use the Brewfile, tap hombrew/bundle to install the command,
# then run it in a directory containing a brewfile.
# 
# > brew tap homebrew/bundle
# > brew bundle

# Make sure we're using the latest homebrew
update

# Upgrade any already-installed formula
upgrade --all

# Tap some repos
tap caskroom/cask
tap homebrew/dupes
tap telemachus/desc

# Install some brew-related stuff
install brew-cask
install brew-desc

# Install shells and completion
install bash
install bash-completion
install zsh
install zsh-completions
install zsh-history-substring-search
install zsh-syntax-highlighting
install mobile-shell

# Install vim
install vim
install macvim

# Install command line utilities
install ack
install archey
install cdf
install colordiff
install ctags
install curl
install elinks
install gist
install git
install grc
install grep
install htop-osx
install iftop
install ipcalc
install ncdu
install pcre
install python
install readline
install reattach-to-user-namespace
install rename
install the_silver_searcher
install tmux
install unrar
install wget
install xz
install youtube-dl

# Cleanup any outdated formulas from the cellar
cleanup

# Run brew doctor to make sure there aren't any problems
doctor
