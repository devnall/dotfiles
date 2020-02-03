# Homebrew Cask in userspace
export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"

function brewupd() {
  echo "---> Updating brews"
  brew update
  echo "---> The following packages can be upgraded:"
  brew outdated
}

function brewupg() {
  echo "---> Upgrading installed brews"
  brew upgrade
  echo "---> Cleaning up brews"
  brew cleanup
}

function bubu() {
  brewupd
  brewupg
  echo "---> Running brew doctor"
  brew doctor
  echo "---> Pruning old brew symlinks"
  brew cleanup
}
