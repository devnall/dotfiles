##########
# This file is sourced by all *interactive* shells on startup.
# This file *should generate no output* or it will break scp and rcp.
##########

##########
# Aliases
##########

# Figure out if you're using OSX or Linux and handle ls colors approrpiately
# For LS_COLORS template: $ dircolors /etc/DIR_COLORS
if [[ `uname` == 'Darwin' ]]; then
	alias ls="ls -G"
	export LSCOLORS=exfxcxdxbxGxDxabagacad
else
	alias ls="ls --color=auto"
	export LS_COLORS='no=00:fi=00:di=00;36:ln=00;35:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;31:'
fi

alias ll='ls -alhF'
alias rm='rm -i'
alias du='du -h'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cl='clear'
alias cp='cp -i'
alias mv='mv -i'
alias ff='find . -name $1'
alias tf='tail -f'
alias ssr='ssh -l root'
alias screen='screen -T xterm-color'
alias whatismyip='curl -s myip.dk|grep '"Box"'|egrep -o '[0-9.]+''
#alias zen='~/bin/work/zen.py'
alias gvim='/usr/local/bin/mvim'
alias grep='GREP_COLOR="1;37;41" grep --color=auto'
alias flushdns='dscacheutil -flushcache'
if [[ `which cdf` == '/usr/local/bin/cdf' ]]; then
	alias df="cdf -h"
else
	alias df='df -h'
fi

if [[ `uname` == 'Darwin' ]]; then
	alias irb="irb --prompt inf-ruby"
fi

##########
# Bash history
##########
export PAGER="less"
export EDITOR="vim"
export HISTCONTROL=erasedups
export HISTSIZE=5000
export HISTIGNORE="&:pwd:ls:ll:la:lsd:exit:cl"
shopt -s histappend

##########
# PATH
##########
if [ -d ~/bin ] ; then
	PATH="~/bin:${PATH}"
fi

if [ -d /usr/local/bin ] ; then
	PATH="/usr/local/bin:${PATH}"
fi

if [ -d /usr/local/sbin ] ; then
	PATH="${PATH}:/usr/local/sbin"
fi

if [ -d /Library/Frameworks/Python.framework/Versions/2.7/bin ] ; then
	PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
fi

# export PATH="${PATH}/Library/Frameworks/Python.framework/Versions/3.1/bin"
# export PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/3.0/bin"

# Bash prompt
PS1="\[\033[0;31m\][\$(date +%H:%M)]\[\033[0m\]\u@\h:\[\033[0;36m\]\W\[\033[0m\]\$ "

#
# Powerline
. /Library/Python/2.7/site-packages/Powerline-beta-py2.7.egg/powerline/bindings/bash/powerline.sh

#test -r /sw/bin/init.sh && . /sw/bin/init.sh

# RFC Function
# Written by DSnyder to quickly search/display RFCs

rfc() {
        if [ "index" = $1 ]
        then
                rfc="-index"
        else
                rfc=`printf "%04d" $1`
        fi
        wget -qO - http://www.ietf.org/rfc/rfc$rfc.txt \
        | sed 's/^[       ]*$//' | ${PAGER:-more}
}

# Autocomplete Hostnames in ~/.ssh/known_hosts

function autoCompleteHostname() {
   local hosts;
   local cur;
   hosts=($(awk '{print $1}' ~/.ssh/known_hosts | cut -d, -f1));
   cur=${COMP_WORDS[COMP_CWORD]};
   COMPREPLY=($(compgen -W '${hosts[@]}' -- $cur ))
}

complete -F autoCompleteHostname ssh
complete -F autoCompleteHostname ssr
