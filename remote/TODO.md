# TODO

This `remote/` directory is intended to hold two files: `.zshrc.remote` and
`.vimrc.remote`. These should be barebones config files that will work on any
system using out-of-the box options. Any plugins or extensions or extras that
need to be installed should be commented out by default.

In addition to being able to manually scp these files to a remote host for a
consistent environment, the `push-environment` function defined in
`.dotfiles/zsh/lib/ssh.zsh` can be used to push both files to a remote host.

I need to create both of those files...
