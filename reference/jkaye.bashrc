# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Clear out the aliases.  Get rid of offensive
# aliases that are provided by major OS vendors.
# I'm thinking of a certain Linux vendor here.
# You know who you are.
for al in `alias | cut -d'=' -f1 | awk '{print $2}'` ; do 
    unalias "$al" 
done

# Showlast function.  If set as PROMPT_COMMAND,
# will automatically set the xterm title bar
# as the last executed command
showlast() {
	LCOMMAND=`history 1`
	export LASTCOMMAND=${LCOMMAND:23}
	echo -ne "\033]0;${HOSTNAME}: ${LASTCOMMAND}\007"
}

# Push ssh public dsa and rsa key onto a remote server.
ssh-putkey() {

    # Make sure user and host are given
    if [ "$1" = "" ] ; then
	echo "ssh-putkey user@host [user@host ... user@host]"
	return 0
    fi 

    # Check for dsa pubkey.
    if [ -f ${HOME}/.ssh/id_dsa.pub ] ; then
	
	# Loop through all servers and send pubkey.
	for remotehost in $@ ; do
	    cat ${HOME}/.ssh/id_dsa.pub | ssh $remotehost 'mkdir .ssh 2>/dev/null ; cat - >> .ssh/authorized_keys ; chmod 700 .ssh ; chmod 600 .ssh/authorized_keys' 
	    
	done # Close loop.

    fi # close check of id_dsa.pub

    # Check for rsa pubkey.
    if [ -f ${HOME}/.ssh/id_rsa.pub ] ; then
	
	# Loop through all servers and send pubkey.
	for remotehost in $@ ; do
	    cat ${HOME}/.ssh/id_rsa.pub | ssh $remotehost 'mkdir .ssh 2>/dev/null ; cat - >> .ssh/authorized_keys ; chmod 700 .ssh ; chmod 600 .ssh/authorized_keys' 
	    
	done # Close loop.

    fi # close check of id_rsa.pub

} # close ssh-putkey

# Push new .bashrc, .bash_profile, and .emacs  onto remote host
push-environment() {
    
    # Make sure $1 is valid
    if [ "$1" = "" ] ; then
	echo "push-environment [user@]host [[user@]host ... [user@]host]"
	return 1
    fi

    # Make sure .bashrc exists.
    if [ ! -r ${HOME}/.bashrc ] ; then
	return 1
    fi

    # Make sure .bash_profile exists.
    if [ ! -r ${HOME}/.bash_profile ] ; then
	return 1
    fi

    # Make sure .bash_profile exists.
    if [ ! -r ${HOME}/.emacs ] ; then
	return 1
    fi

    # Copy the files
    for desthost in $@ ; do
	scp ${HOME}/.bashrc ${HOME}/.bash_profile ${HOME}/.emacs ${desthost}:
    done
    
} # Close push-environment

# Pull .bashrc, .bash_profile, and .emacs from remote host
pull-environment() {
    
    # Make sure $1 is valid
    if [ "$1" = "" ] ; then
	echo "pull-environment [user@]host"
	return 1
    fi

    # Copy those files from the remote locale.
    desthost="$1"
    scp ${desthost}:.bashrc ${desthost}:.bash_profile ${desthost}:.emacs ${HOME}

} # Close pull-environment    


# If you're using Solaris and xterm, lie about TERM
if [ "`uname`" = "SunOS" ] ; then
    if [ "$TERM" = "xterm" ] ; then
	TERM=dtterm
	export TERM
    fi # end xterm check
fi # end SunOS check

# If you're using Solaris and xterm-color, lie about TERM
if [ "`uname`" = "SunOS" ] ; then
    if [ "$TERM" = "xterm-color" ] ; then
	TERM=dtterm
	export TERM
    fi # end xterm-color check
fi # end SunOS check

# If you're using HP-UX and xterm, lie about TERM
if [ "`uname`" = "SunOS" ] ; then
    if [ "$TERM" = "xterm" ] ; then
	TERM=vt100
	export TERM
    fi # end xterm check
fi # end HP-UX check

# If you're using Linux and dtterm, lie about the TERM
if [ "`uname`" = "Linux" ] ; then
    if [ "$TERM" = "dtterm" ] ; then
	TERM=xterm-color
	export TERM
    fi # end xterm check
fi # end Linux check

# Determine initial prompt color based on a
# hash of the hostname.
colormax=7
hosthash=`hostname | cksum | awk '{print $1}'`
numhash=`hostname | cksum | awk '{print $2}'`
hctemp=$(( $hosthash % $colormax ))
numtemp=$(( $numhash % $colormax ))
hostcolor=$(( $hctemp + 1 ))
numcolor=$(( $numtemp + 1 ))
    
	
# Create a smiley prompt.
function setprompt {

    # Create an array of foreground colors
    # that work with the background color.
    hostfg[1]=0
    hostfg[2]=0
    hostfg[3]=0
    hostfg[4]=7
    hostfg[5]=0
    hostfg[6]=0
    hostfg[7]=0

    case $TERM in
	xterm*|Eterm|dtterm|rxvt|sun)
	    if [ "$LOGNAME" = "root" ] ; then
		DUDE='\[\e[31m\]root\[\e[0m\]'
	    else
		DUDE="\[\e[36m\]${LOGNAME}\[\e[0m\]"
	    fi
	    
	    PROMPT_COMMAND="showlast"
	    FACE[0]='=)'
	    FACE[1]='=('
	    PS1_COLORED_DIRECTORY='\[\e[33m\]\w\[\e[0m\]'
	    PS1_COLORED_HOST="\[\e[4${hostcolor};3${hostfg[${hostcolor}]}m\]\h\[\e[0m\]"
	    PS1_COLORED_NUM="\[\e[4${hostfg[${numcolor}]};3${numcolor}m\][\!]\[\e[0m\]"
	    PS1_COLORED_FACE='\[\e[$[($?)?31:32]m\]${FACE[$[($?)?1:0]]}\[\e[0m\]'
	    export PS1="${DUDE}@${PS1_COLORED_HOST} ${PS1_COLORED_NUM} ${PS1_COLORED_DIRECTORY} ${PS1_COLORED_FACE} \\$ "
	    ;;
	linux)
	    if [ "$LOGNAME" = "root" ] ; then
		DUDE='\[\e[31m\]root\[\e[0m\]'
	    else
		DUDE="\[\e[36m\]${LOGNAME}\[\e[0m\]"
	    fi
	    
	    FACE[0]='=)'
	    FACE[1]='=('
	    PS1_COLORED_DIRECTORY='\[\e[33m\]\w\[\e[0m\]'
	    PS1_COLORED_FACE='\[\e[$[($?)?31:32]m\]${FACE[$[($?)?1:0]]}\[\e[0m\]'
	    PS1_COLORED_NUM="\[\e[4${hostfg[${numcolor}]};3${numcolor}m\][\!]\[\e[0m\]"
	    PS1_COLORED_HOST="\[\e[4${hostcolor};3${hostfg[${hostcolor}]}m\]\h\[\e[0m\]"
	    export PS1="${DUDE}@${PS1_COLORED_HOST} ${PS1_COLORED_NUM} ${PS1_COLORED_DIRECTORY} ${PS1_COLORED_FACE} \\$ "
	    ;;
	*)
	    if [ "$LOGNAME" = "root" ] ; then
		DUDE='root'
	    else
		DUDE="${LOGNAME}"
	    fi
	    
	    FACE[0]='=)'
	    FACE[1]='=('
	    PS1_COLORED_DIRECTORY='\w'
	    PS1_COLORED_NUM='[\!]'
	    PS1_COLORED_FACE='${FACE[$[($?)?1:0]]}'
	    export PS1="${DUDE}@\h ${PS1_COLORED_NUM} ${PS1_COLORED_DIRECTORY} ${PS1_COLORED_FACE} \\$ "
	    ;;
    esac
} # close setprompt

# Create a function to set prompt color and
# allow you to change it.
function promptcolor {
    input=$1
    
    # Based on the input, modify the hostcolor.  If it's null, return hostcolor.
    if [ "$input" = "" ] ; then
	echo $hostcolor
	return
    else
	case $input in 
	    next)
		hostcolor=$(( $hostcolor + 1 ))
		numcolor=$(( $numcolor + 1 ))
		;;
	    prev)
		hostcolor=$(( $hostcolor - 1 ))
		numcolor=$(( $numcolor - 1 ))
		;;
	    random)
		hostcolor=$(( $RANDOM % $colormax ))
		numcolor=$(( $RANDOM % $colormax ))
		;;
	    *)
		hostcolor=$input
		;;
	esac
	
	# Sanity check that your hostcolor is within reasonable values
	if [ $hostcolor -gt $colormax ] ; then
	    hostcolor=1
	fi

	if [ $numcolor -gt $colormax ] ; then
	    numcolor=1
	fi

	if [ $numcolor -lt 1 ] ; then
	    numcolor=$colormax
	fi

	if [ $numcolor -lt 1 ] ; then
	    numcolor=$colormax
	fi
	
    fi # close if input=""

    # Update the prompt
    setprompt

} # close function promptcolor

# Set the initial prompt with the setprompt function.
setprompt

# Initialize CMDLIST
CMDLIST=""

# Show a preferred command list
function cmds() {
    oldhtf="$HISTTIMEFORMAT"
    unset HISTTIMEFORMAT
    history | egrep "${CMDLIST:2}" | egrep -v 'addc|delc'
    HISTTIMEFORMAT="$oldhtf"
}

# Add a command to preferred command list
function addc() {
    for cmdid in "$@" ; do 
	CMDLIST="$CMDLIST | $cmdid "
    done
}

# Delete a command from the preferred command list
function delc() {
    for cmdid in "$@" ; do
	CMDLIST=`echo $CMDLIST | sed -e "s/| ${cmdid} //g;s/| ${cmdid}\$//g"`
    done
}


# Configure the PATH, MANPATH, LD_LIBRARY_PATH variable
paths=( \
"$HOME/bin" \
"/usr/local/coreutils/bin" \
"/usr/bin" \
"/bin" \
"/opt/csw/bin" \
"/opt/sfw/bin" \
"/usr/local/bin" \
"/usr/sbin" \
"/sbin" \
"/opt/csw/sbin" \
"/opt/sfw/sbin" \
"/usr/local/sbin" \
"/usr/dt/bin" \
"/usr/X11R6/bin" \
"/usr/openwin/bin" \
"/cygdrive/c/Perl/bin" \
"/cygdrive/c/Program Files/Common Files/GTK/2.0/bin" \
"/cygdrive/c/Program Files/cvsnt" \
"/cygdrive/c/WINDOWS" \
"/cygdrive/c/WINDOWS/System32/Wbem" \
"/cygdrive/c/WINDOWS/system32" \
"/opt/VRTS/bin" \
"/opt/VRTSvxfs/bin" \
"/opt/VRTSob/bin" \
"/opt/VRTSvcs/bin" \
"/etc/vx/bin"  \
"/opt/Navisphere/bin" \
"/usr/proc/bin" \
"/usr/openv/netbackup/bin" \
"/usr/openv/netbackup/bin/admincmd" \
"/usr/openv/volmgr/bin" \
"/usr/ccs/bin" \
"/opt/java/bin" \
"/opt/CyberFusion" \
"/usr/kerberos/bin" \
"/usr/games" \
"/opt/java" \
"/opt/jUploadr" \
"/usr/ucb"
"/usr/openv/netbackup/bin/admincmd" \
"/usr/openv/netbackup/bin/goodies" \
"/usr/openv/volmgr/bin" \
"/sw/bin" \
"/sw/sbin" \
"/opt/perf/bin" \
"/opt/local/bin" \
"/opt/local/sbin" \
)

manpaths=( \
"/usr/local/coreutils/man" \
"/usr/man" \
"/usr/share/man" \
"/opt/csw/man" \
"/opt/sfw/man"
"/usr/local/man" \
"/usr/X11R6/man" \
"/usr/dt/man" \
"/opt/VRTS/man" \
"/opt/Navisphere/man" \
"/usr/openv/man" \
"/sw/man" \
"/opt/local/man" \
)
 
ldpaths=( \
"/lib" \
"/usr/lib" \
"/usr/share/lib" \
"/usr/X11R6/lib" \
"/usr/dt/lib" \
"/opt/csw/lib" \
"/usr/local/lib" \
"/sw/lib" \
"/opt/local/lib" \
)

# Clear out the old paths
PATH=""
MANPATH=""
LD_LIBRARY_PATH=""

# Add only paths that exist.  Add them in the order
# as designated in the $paths array above.
for currentpath in "${paths[@]:0}" ; do     
    if [ -d "$currentpath" ] ; then
	PATH="${PATH}:${currentpath}"
    fi
done

for currentpath in "${manpaths[@]:0}" ; do     
    if [ -d "$currentpath" ] ; then
	MANPATH="${MANPATH}:${currentpath}"
    fi
done

for currentpath in "${ldpaths[@]:0}" ; do     
    if [ -d "$currentpath" ] ; then
	LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${currentpath}"
    fi
done

# Clear off the leading ":" on these paths
PATH=${PATH:1}
MANPATH=${MANPATH:1}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH:1}

# Add in support for the RSC if this is Sun hardware
if [ "`uname`" = "SunOS" ] ; then
    rscdir=/usr/platform/`uname -i`/rsc
    if [ -d $rscdir ] ; then
	PATH=$PATH:$rscdir
    fi # Close if -d
fi # Close if SunOS

# Add in support for the ALOM if this is Sun hardware
if [ "`uname`" = "SunOS" ] ; then
    scdir=/usr/platform/`uname -i`/sbin
    if [ -d $scdir ] ; then
	PATH=$PATH:$scdir
    fi # Close if -d
fi # Close if SunOS

# Check for editors in reverse preference order
# (least favorite to most favorite)
editor_list="vi pico nano emacs"
for editor in $editor_list ; do
    whout=`which $editor 2>/dev/null`
    if [ "${whout:0:1}" = "/" ] ; then
	EDITOR=$editor
	if [ "$EDITOR" = "emacs" ] ; then
	    EDITOR='emacs -nw'
	fi # Close if editor = emacs
	VISUAL=$EDITOR
    fi # Close if whout
done # close for editor

# Check for pagers in reverse preference order
# (least favorite to most favorite)
pager_list="pg more less"
for pager in $pager_list ; do
    whout=`which $pager 2>/dev/null`
    if [ "${whout:0:1}" = "/" ] ; then
	PAGER=$pager
	alias less=$pager
    fi # close whout=/
done # close for pager

# Make an lscc alias which runs ls --color --classify, but only
# if supported.
if ls --color --classify > /dev/null 2>&1 ; then
    alias lscc="ls --color --classify"
elif gls --color --classify > /dev/null 2>&1 ; then
    alias lscc="gls --color --classify"
elif /sw/bin/ls --color --classify > /dev/null 2>&1 ; then
    alias lscc="/sw/bin/ls --color --classify"
else
    alias lscc="ls -F"
fi

# Make an lsg alias, which runs ls --color --classify
# and pipes through the best avaialble grep, color if possible.
# Start by testing for grep's color support.
echo "hello" | grep --color lo > /dev/null 2>&1
retval=$?
if [ $retval -eq 0 ] ; then
    alias lsg="lscc | grep -i --color"
else
    alias lsg="lscc | grep -i"
fi

# History Grep (hg) alias.
alias hg="history | grep -i"

# fakesudo()
# There are still some OS deployments that lack a 
# corresponding sudo deployment.  This function uses
# su(1) to emulate the behavior of sudo -s
# Of course, you will need to enter the root password,
# not your own like in sudo.  The printf will remind
# people of that.
fakesudo() {
    printf "Enter The Root "
    su - root -c "bash --rcfile ${HOME}/.bashrc"
} # end fakesudo()

# Set aliases as necessary
alias emacs="emacs -nw"
alias xterm="xterm -bg black -fg white"
alias 3xterm="xterm -bg black -fg white & xterm -bg black -fg white &xterm -bg black -fg white&"
alias fixmouse="sudo modprobe -r psmouse ; sudo modprobe psmouse"
alias rxvt="rxvt -tn rxvt"
alias cegrep="egrep --color=auto"
alias cgrep="grep --color=auto"
alias cfgrep="fgrep --color=auto"
alias sab="ssh-agent bash"
alias sa="ssh-add"

# If there is a /usr/local/bin/wiscan3.pl, make
# an alias to find open wifi.
if [ -x /usr/local/bin/wiscan3.pl ] ; then
    alias openwifi="sudo /usr/local/bin/wiscan3.pl | egrep 'Name|off|\+'"
fi

# Add powermt and powercf aliases, but only if they exist.
if [ -f /etc/powermt ] ; then
    alias powermt=/etc/powermt
fi

if [ -f /etc/powercf ] ; then
    alias powercf=/etc/powercf
fi

# Fix the irritating default behavior of RHEL 6 sudo -s
if [[ `cat /etc/*release | grep "release 6"` ]]; then
    sudo() {
        if [[ $@ == "-s" ]]; then
            sudo bash -c "HOME=$HOME; exec bash"
        else
            command sudo "$@";
        fi;
    }
fi;

# Backup and unset anything that should be unset
OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
unset LD_LIBRARY_PATH

# Date the shell history
HISTTIMEFORMAT='%Y%m%d %H:%M  '

# Export all of the variables set thus far.
export EDITOR VISUAL PAGER PATH MANPATH OLD_LD_LIBRARY_PATH HISTTIMEFORMAT

# If there is a user-specific .bashrc, source it now
userbashrc=${HOME}/.bashrc.${LOGNAME}
if [ -f $userbashrc ] ; then
    source $userbashrc
fi

# If there is a host-specific .bashrc, source it now
hostbashrc=${HOME}/.bashrc.`hostname`
if [ -f $hostbashrc ] ; then
    source $hostbashrc
fi

# Export the BASHRC_VERSION
BASHRC_VERSION="20131113"
export BASHRC_VERSION

# ---------------------- Changelog ----------------------
# This changelog comment section is new for
# BASHRC_VERSION 20081219 and above.
#
# BASHRC_VERSION  Modification
# 20081219        Added lscc alias for /sw/bin/ls
# 20081219        Added /sw/sbin path.
# 20081219        Added a changelog comment section
# 20081219        Added editor preference path
# 20081219        Added pager preference path
# 20081219        Moved BASHRC_VERSION to the end for easy editing.
# 20081223        Fixed bug with less alias
# 20090522        Added /usr/local/coreutils for HP-UX
# 20090522        Added /opt/perf/bin for HP-UX
# 20090522        Fixed emacs -nw EDITOR bug
# 20090629        Unset LD_LIBRARY_PATH
# 20090721        Add host-specific .bashrc source
# 20090721        Add paths and manpaths for macports
# 20090721        Backup LD_LIBRARY_PATH as OLD_LD_LIBRARY_PATH
#                 before unsetting it.
# 20090803        Added ssh-putkey function
# 20090803        Added push-environment function
# 20090803        Added /opt/VRTSvcs/bin to paths
# 20091029        Add powermt and powercf aliases if necessary
# 20091210        Add support for platform-dependent RSC.
# 20100322        Unset aliases that were previously set
#                 before running script to eliminate
#                 vendor-specific aliases
# 20100322        Modify RSC support to not call
#                 uname -i on non-Sun hardware because
#                 it broke .bashrc on Darwin.
# 20100322        Fix .ssh not found bug in ssh-putkey
# 20100608        Fix issue with less alias
# 20100608        Remove CFROOT stanza.  CFROOT should
#                 be handled only in .bashrc.$hostname
# 20100608        Minor bug in push-environment usage output
# 20100624        Set the prompt color based on a hash of the hostname.
# 20100624        Allow for an argument vector of hosts in ssh-putkey
#                 and push-environment, rather than a single host entry.
# 20100624        Add for user-specific .bashrc enhancements with the
#                 .bashrc.username file.  This way, other users can
#                 benefit from my .bashrc without having to fork from
#                 The original.  To use this, create a file in your
#                 home directory called .bashrc.username, replacing
#                 username with your login name.
# 20110119        Add aliases for cegrep, cgrep, cfgrep
# 20110119        Add openwifi alias if /usr/local/bin/wiscan3.pl exists.
# 20110304        Add support for rsa pubkeys to ssh-putkey.
# 20110304        Add fakesudo function.
# 20110304        Add ALOM support to path.
# 20110316        Improve fakesudo prompt
# 20110408        Add pull-environment() to get configs from a remote server.
# 20110408        Add lsg method. Reimplementing a coworker's ls|grep
# 20110411        Add xterm-color routine for solaris hosts.
# 20110607        Add hg alias to grep history
# 20110609        Add colored prompt history and expanded color hash
#                 so that history color and host color are not
#                 necessarily the same.
# 20110609        Define HISTTIMEFORMAT to alow for history time
#                 stamping
# 20110609        Change offset in showlast() to account for
#                 history time stamping.
# 20110613        Add addc, delc, cmds functions for custom
#                 command repetition.

# 20131113        Add sudo function to fix RHEL 6 not keeping $HOME
# 20131113        Added aliases "sab" and "sa" to make spawning ssh
#                 agents easier.

