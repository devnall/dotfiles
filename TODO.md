TODO: Fix up minimal vim. Needs to at least have a decent colorscheme and not throw errors at start.
TODO: On all machine types other than "Remote" (that is, on Work, Personal, and Remote-Full machines), if nvim is installed, alias something to it. I have muscle memory to type "vim" but if it's bad form to alias nvim to vim, I should find a new alias -- maybe "e" for "edit"?
TODO: Archive/remove Alacritty configs.
TODO: Try to remove external dependecy in `bat` for the `rose-pine-dawn` theme. Try to create a local copy of the theme. If successful, remove the step from `install.config.yaml` to curl the theme (and any associated documentation that would no longer be relevant).
TODO: Implement automatic dark/light theme switching on macOS appearance change. Affects tmux and btop (and potentially others). Best approach: `brew install dark-notify` (keith/formulae) + a LaunchAgent that fires callbacks on appearance change — e.g. `tmux source ~/.config/tmux/tmux.conf` and a btop config patcher. Design the solution holistically across all affected tools before implementing. Alternately, consider a native polling approach to reduce external dependencies.
TODO: See if I can get custom btop NordicPine theme
TODO: Document my theme palletes independently of shell configs, so that I can use them other places.
TODO: Figure out 1Password "op" cli tool and the permissions popups for it I keep getting.
