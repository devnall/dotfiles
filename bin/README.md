# bin

Scripts I keep on `PATH` (linked into `~/bin`).

| Script | What it does |
|---|---|
| `theme-switch dark\|light` | Re-themes tmux, Neovim, btop, Claude Code and the wallpaper, and writes the appearance state file. Called by dark-notify. Wallpapers come from `~/Pictures/wallpapers` (a clone of [devnall/wallpapers](https://github.com/devnall/wallpapers)) or `~/.local/share/wallpapers/{dark,light}.jpg`. |
| `dark-notify-load` | (Re)loads the dark-notify LaunchAgent, so a changed plist takes effect without a logout |
| `wallpaper-setup` | Moves from one wallpaper per mode to rotating folders from [devnall/wallpapers](https://github.com/devnall/wallpapers), per display shape |
| `tunes.js` | Prints the current Apple Music track for the tmux status bar (`osascript -l JavaScript`) |
| `tmux-ssh-fzf` | fzf popup (`prefix S`) over the hosts in your SSH config; opens the chosen host in a new tmux window |
| `cheat.sh` | Browses the cheatsheets in [`docs/`](../docs/) with fzf |
| `curlperf URL` | Prints connect time + time to first byte = total, from curl |
| `tailscale-variant-check` | Checks that a Mac runs Tailscale's standalone build, not the App Store one. Only the standalone build has `tailscale ssh` and puts a CLI on `PATH`. Explains how to switch; never fails. |
| `linux-bat-install` | Installs or updates bat from its GitHub releases on Linux. The bat config needs 0.25+ options (`--theme=auto:system`); apt has those from Ubuntu 26.04 and Debian 13, but not on Ubuntu 24.04 or Debian 12 |
