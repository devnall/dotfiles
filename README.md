/dev/nall's dotfiles
====================

A bunch of dotfiles for my environment and config files for my tools, including:

* zsh

* vim

* tmux

* BASH (deprecated)

* screen (deprecated)

These are a work in progress (and likely always will be) and are in dire need of a cleanup.

The (deprecated) stuff isn't really being used in my current environment but I'm keeping it around in case I end up on an old box without the new hotness.

Requirements
------------

Symlink `.zshrc`, `.vimrc`, and `.tmux.conf` into ~

For vim to work, first install Vundle:
`git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle`

TODOs
-----

* Cleanup zsh/lib/git.zsh; there are a ton of aliases I never use/remember, probably also some functions that aren't necessary
* Setup chez moi or similar for better dotfile management/setup
* Document/update the brewfile stuff
* Consolidate my separate `vim` repo into this one
