#!/bin/sh

# A simple script to make use of
# http://robots.thoughtbot.com/brewfile-a-gemfile-but-for-homebrew

# Make sure we're using the latest homebrew
brew update;

# Upgrade any already-installed formula
brew upgrade --all;

# Run bundle to parse Brewfile
brew bundle;

# Cleanup any outdated formula from the cellar
brew cleanup;

# Run brew doctor to make sure there aren't any problems
brew doctor
