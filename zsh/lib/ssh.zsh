# Push ssh public rsa and dsa key onto a remote host
function ssh-putkey() {
    if [ "$1" = "" ]; then
        echo "Usage: ssh-putkey user@host [user@host ... user@host]"
        return 1
    fi

    if [ -f ${HOME}/.ssh/id_rsa.pub ]; then
        for remotehost in $@; do
            cat ${HOME}/.ssh/id_rsa.pub | ssh $remotehost 'mkdir .ssh 2>/dev/null ; cat - >> .ssh/authorized_keys ; chmod 700 .ssh ; chmod 600 .ssh/authorized_keys'
        done
    fi

    if [ -f ${HOME}/.ssh/id_dsa.pub ]; then
        for remotehost in $@; do
            cat ${HOME}/.ssh/id_dsa.pub | ssh $remotehost 'mkdir .ssh 2>/dev/null ; cat - >> .ssh/authorized_keys ; chmod 700 .ssh ; chmod 600 .ssh/authorized_keys'
        done
    fi
}

# Push barebones .zshrc.remote and .vimrc.remote onto a remote host
function push-environment() {
    if [ "$1" = "" ]; then
        echo "Usage: push-environment [user@]host [[user@]host ... [user@]host]"
        return 1
    fi

    # Make sure the files exist
    if [ ! -r ${HOME}/.dotfiles/remote/.zshrc.remote ]; then
        echo "Error: Missing ~/.dotfiles/remote/.zshrc.remote file"
        return 1
    elif [ ! -r ${HOME}/.dotfiles/remote/.vimrc.remote ]; then
        echo "Error: Missing ~/.dotfiles/remote/.vimrc.remote file"
        return 1
    else
        for remotehost in $@; do
            scp ${HOME}/.dotfiles/remote/.zshrc.remote ${desthost}:${HOME}/.zshrc
            scp ${HOME}/.dotfiles/remote/.vimrc.remote ${desthost}:${HOME}/.vimrc
        done
    fi
}