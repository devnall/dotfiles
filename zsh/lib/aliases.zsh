# Reload zsh config
alias reload!='source ~/.zshrc'

# Super user
alias _='sudo'

# Directory listing

if [[ `uname` == 'Darwin' ]]; then # MacOS
  ls_colorflag="-G"
  alias lsal='CLICOLOR_FORCE=1 ls -lahF ${ls_colorflag} | less -R'
  if [[ -f "$HOMEBREW_PREFIX/bin/eza" ]]; then
    alias l='eza --long --all --classify --time-style=relative --color-scale size --no-permissions --octal-permissions --icons --git --group-directories-first'
    alias ll='eza --long --all --header --classify --time-style=long-iso --group --color-scale size --octal-permissions --icons --git --git-repos --group-directories-first'
    alias la='eza --long --all --header --classify --time-style=long-iso --group --color-scale age --octal-permissions --icons --git --git-repos --group-directories-first'
    alias lt='eza --long --all --classify --time-style=relative --color-scale size --no-permissions --octal-permissions --icons --git --group-directories-first --tree --level=3'
  elif [[ -f "$HOMEBREW_PREFIX/bin/exa" ]]; then
    alias l='exa -laFh --color-scale --icons --git'
    alias ll='exa -laFh --time-style=long-iso --group --binary --color-scale --icons --git --group-directories-first'
    alias la='exa -aFh --color-scale'
    echo 'exa is deprecated, switch to eza'
  else
    alias l='ls -lAhF ${ls_colorflag}'
    alias ll='ls -lhF ${ls_colorflag}'
    alias la='ls -AhF ${ls_colorflag}'
    alias lsa='ls -lahF ${ls_colorflag}'
  fi
else # Linux
  ls_colorflag="--color"
  if [[ -f "$HOMEBREW_PREFIX/bin/eza" ]]; then
    alias l='eza --long --all --classify --time-style=relative --color-scale size --no-permissions --octal-permissions --icons --git --group-directories-first'
    alias ll='eza --long --all --header --classify --time-style=long-iso --group --color-scale size --octal-permissions --icons --git --git-repos --group-directories-first'
    alias la='eza --long --all --header --classify --time-style=long-iso --group --color-scale age --octal-permissions --icons --git --git-repos --group-directories-first'
    alias lt='eza --long --all --classify --time-style=relative --color-scale size --no-permissions --octal-permissions --icons --git --group-directories-first --tree --level=3'
  else
    alias l='ls -lAhF ${ls_colorflag}'
    alias ll='ls -lhF ${ls_colorflag}'
    alias la='ls -AhF ${ls_colorflag}'
    alias lsa='ls -lahF ${ls_colorflag}'
    alias lsal='ls -lahF ${ls_colorflag} | less -R'
  fi
  # Fix other-writable (ow) directory color: default 34;42 (blue on ANSI green) is
  # unreadable on dark terminal themes where ANSI green maps to a dark color.
  # 1;34 = bold blue, no background — readable on any theme.
  export LS_COLORS="${LS_COLORS:+$LS_COLORS:}ow=1;34:tw=1;36"
fi

# Other
alias rm='rm -i'
alias du='du -h'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias pu="pushd"
alias po="popd"
alias ssr="ssh -l root"
alias ports='netstat -tulan' # show open ports
alias k8='kubectl'
alias cls='printf "\033c"'   # clear screen

# If prettyping is installed, use it instead of ping
if [[ -f "$HOMEBREW_PREFIX/bin/prettyping" ]]; then
  alias ping="prettyping --nolegend"
fi

# If btop or htop is installed, use it instead of top
if [[ -f "$HOMEBREW_PREFIX/bin/btop" ]]; then
  alias top="btop"
elif [[ -f "$HOMEBREW_PREFIX/bin/htop" ]]; then
  alias top="htop"
fi

# If GNU date is installed, use it instead of old date shipped w/ MacOS
if [[ -f "$HOMEBREW_PREFIX/bin/gdate" ]]; then
  alias date="gdate"
fi

# If ncdu is installed, use it instead of du
if [[ -f "$HOMEBREW_PREFIX/bin/ncdu" ]]; then
  alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
fi

# No `free` command on OSX, here's a hacky substitute
if [[ `uname` == 'Darwin' ]]; then
  alias free="/usr/bin/top -l 1 -s 0 | grep PhysMem"
fi

if command -v bat > /dev/null; then
  alias batp='bat -p'
  alias bat_='bat --show-all'
fi

# Retrain my youtube-dl muscle memory
alias youtube-dl='echo "Use yt-dlp instead!"'

# Get IP Addresses
# TODO: Turn this into a function that can handle different OSes
alias ip='echo "External IP:   " `dig +short myip.opendns.com @resolver1.opendns.com` && echo "Ethernet (en3):" `ipconfig getifaddr en3` && echo "Wireless (en0):" `ipconfig getifaddr en0`'

# Recursively delete `.DS_Store` files
alias dscleanup="find . -name '*.DS_Store' -type f -ls -delete"

# ROT13 encode/decode
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash"

if command -v lazygit > /dev/null; then
  alias lg='lazygit'
fi

# kubectl stuff
alias klusters="kubectl config get-contexts | tr -s ' ' | cut -d ' ' -f 2 | sort"

# Weather and moon phase
alias weather="curl -s 'wttr.in/Atlanta?u' | head -n 38 | tail -n 37"
alias moon="curl -s wttr.in/Moon | head -n 23"

# Open current terminal path in Finder.app
if [[ `uname` == 'Darwin' ]]; then
  alias finder="open ./"
fi

# Neovim aliases (interactive shell only — EDITOR stays as vim for scripts)
if command -v nvim > /dev/null; then
  alias vim='nvim'
  alias e='nvim'
fi

# Suffix aliases
# Allow you to do someting like `alias -s md=vim`; then just entering a file that ends in .md `$ README.md` will open it in vim
# Could also do stuff like `alias -s html=w3m` to open *.html files in w3m browser or even `alias -s org=w3m` to open sites ending in `.org` in w3m
