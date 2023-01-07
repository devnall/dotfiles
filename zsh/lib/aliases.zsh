# Reload zsh config
alias reload!='source ~/.zshrc'

# Super user
alias _='sudo'

# Directory listing

if [[ `uname` == 'Darwin' ]]; then # MacOS
  ls_colorflag="-G"
  alias lsal='CLICOLOR_FORCE=1 ls -lahF ${ls_colorflag} | less -R'
  if [[ -f "$HOMEBREW_PREFIX/bin/exa" ]]; then
    alias l='exa -laFh --color-scale --icons --git'
    alias ll='exa -laFh --time-style=long-iso --group --binary --color-scale --icons --git --group-directories-first'
    alias la='exa -aFh --color-scale'
  else
    alias l='ls -lAhF ${ls_colorflag}'
    alias ll='ls -lhF ${ls_colorflag}'
    alias la='ls -AhF ${ls_colorflag}'
    alias lsa='ls -lahF ${ls_colorflag}'
  fi
else # Linux
  ls_colorflag="--color"
  alias l='ls -lAhF ${ls_colorflag}'
  alias ll='ls -lhF ${ls_colorflag}'
  alias la='ls -AhF ${ls_colorflag}'
  alias lsa='ls -lahF ${ls_colorflag}'
  alias lsal='ls -lahF ${ls_colorflag} | less -R'
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
if hash fd 2>/dev/null; then
  alias find='echo "No! Use fd instead! So. Much. Faster."'
fi
alias ports='netstat -tulan' # show open ports
alias k8='kubectl'

# If my fork of k is installed (via zplug), alias sane defaults to `k`
if [[ `declare -f k_default > /dev/null; echo $?` -eq 0 ]]; then
  alias k="k_default -Ah"
fi

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
  alias bat='bat --theme="Nord"'
  alias batp='bat -p --theme="Nord"'
  alias bat_='bat --show-all --theme="Nord"'
fi

# Get IP Addresses
# TODO: Turn this into a function that can handle different OSes
alias ip='echo "External IP:   " `dig +short myip.opendns.com @resolver1.opendns.com` && echo "Ethernet (en3):" `ipconfig getifaddr en3` && echo "Wireless (en0):" `ipconfig getifaddr en0`'
#alias localip='echo "Ethernet (en0):" `ipconfig getifaddr en0` && echo "Wireless (en1):" `ipconfig getifaddr en1`'
#alias ips='ifconfig -a | perl -nle"/(\d+\.\d+\.\d+\.\d+)/ && print $1"'

# Recursively delete `.DS_Store` files
alias dscleanup="find . -name '*.DS_Store' -type f -ls -delete"

# ROT13 encode/decode
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash"

# Custom git aliases (override git plugin)
#alias glg="g hist"

# kubectl stuff
alias klusters="kubectl config get-contexts | tr -s ' ' | cut -d ' ' -f 2 | sort"

# Weather and moon phase
alias weather="curl -s wttr.in/Atlanta | head -n 38 | tail -n 37"
alias moon="curl -s wttr.in/Moon | head -n 23"

# Open current terminal path in Finder.app
if [[ `uname` == 'Darwin' ]]; then
  alias finder="open ./"
fi

# Suffix aliases
# Allow you to do someting like `alias -s md=vim`; then just entering a file that ends in .md `$ README.md` will open it in vim
# Could also do stuff like `alias -s html=w3m` to open *.html files in w3m browser or even `alias -s org=w3m` to open sites ending in `.org` in w3m
