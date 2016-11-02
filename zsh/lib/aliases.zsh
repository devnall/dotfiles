# homebrew
alias brews='brew list -1|grep $1'
alias brewupd='brew update && brew outdated'
alias brewupg='brew upgrade && brew cleanup'
alias brewdr='brew doctor'
alias bubu='brewupd && brewupg && brewdr'
