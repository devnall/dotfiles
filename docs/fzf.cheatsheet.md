# fzf Cheatsheet

CTRL+T - find files and directories inside the current directory. Inserts the selection into the command prompt.
CTRL+R - search your shell history and paste into the command line.
ALT+C - find and change into (sub)directory

`<command> ** <TAB>` - contextural fuzzy find completion for relevant command
e.g. `vim ** <TAB>` will give you files and directories (the default for most commands) and let you multi-select them, but if you `ssh ** <TAB>` it'll provide a list of hostnames in you `~/.ssh/known_hosts`, and if you `cd ** <TAB>` it will only offer directories and only allow single selection, since those are the valid arguments to `cd`.

## Reference:
- [fzf](https://junegunn.github.io/fzf/)
- [fzf GitHub Repo](https://github.com/junegunn/fzf)
- [A Practical Guide to fzf: Shell Integration](https://thevaluable.dev/fzf-shell-integration/)
