/dev/nall's dotfiles
====================

A bunch of dotfiles for my environment and config files for my tools, including:

* zsh
* vim
* tmux
* starship prompt

These are a work in progress (and likely always will be) and are in dire need of a cleanup.

The stuff in archive/ isn't really being used in my current environment but I'm keeping it around in case I end up on an old box without the new hotness.

Requirements
------------

- Homebrew installed
- Most of the stuff in the Brewfile installed

- Symlink `.zshrc`, `.vimrc`, `.tmux.conf`, `.ackrc`, `.gitconfig` into ~
- Symlink `starship.toml` into ~/.config

- Call brew's shellenv in .zprofile:

MacOS ARM: `echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile`

MacOS Intel: `echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile`

Linux: `echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile`

- For vim to work, first install vim-plug:
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

TODOs
-----

* Cleanup zsh/lib/git.zsh; there are a ton of aliases I never use/remember, probably also some functions that aren't necessary
* Setup chez moi or similar for better dotfile management/setup
* Document/update the brewfile stuff
* Consolidate my separate `vim` repo into this one
