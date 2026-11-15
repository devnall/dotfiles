# dotfiles

My (public) terminal/CLI setup and tooling; mostly macOS and mostly purged of the parts that only make sense on my machines.
It's zsh, tmux, Neovim and Ghostty, with a custom dark/light theme pair
(**NordicPine** and **AlpineDawn**) that follows the macOS appearance setting everywhere.

This is a curated copy of my private dotfiles. It's meant to be read and
borrowed from, not cloned and installed wholesale. Paths assume the files live
in `~/.dotfiles` and are linked into `~/.config`, the way my own setup does
it with [Dotbot](https://github.com/anishathalye/dotbot).

## What's here

| Path | What it is |
|---|---|
| [`zsh/`](zsh/) | zsh config: a small `zshrc` plus one file per concern in `zsh/lib/` |
| [`config/tmux/`](config/tmux/) | tmux with a `C-a` prefix, vim-style panes, plugins without TPM |
| [`config/nvim/`](config/nvim/) | Neovim on lazy.nvim: LSP, Telescope, Treesitter, blink.cmp |
| [`config/vim/`](config/vim/) | A plugin-free vimrc for servers |
| [`config/ghostty/`](config/ghostty/) | Ghostty, plus both themes |
| [`config/starship/`](config/starship/) | Starship prompts: one local, one for SSH sessions |
| [`docs/color-palettes.md`](docs/color-palettes.md) | Every color in NordicPine and AlpineDawn |
| [`config/bat/`](config/bat/), [`config/btop/`](config/btop/), [`config/glow/`](config/glow/) | The themes, ported to those tools |
| [`config/git/`](config/git/) | Git config: SSH commit signing, aliases, a global ignore |
| [`config/macos/defaults.sh`](config/macos/defaults.sh) | The `defaults write` settings I apply to a new Mac |
| [`bin/`](bin/) | Small scripts I use often |
| [`packages/Brewfile.universal`](packages/Brewfile.universal) | Everything Homebrew installs on every Mac I use |
| [`docs/`](docs/) | Cheatsheets for fzf, git, tmux, vim, Neovim and the shell |

## Dark/Light mode switching, everywhere

Switching macOS between dark and light mode switches everything at once.

- **Ghostty and bat** automagically follow the system setting
- **Everything else**: [dark-notify](https://github.com/cormacrelf/dark-notify)
  runs as a LaunchAgent ([plist](config/launchagents/)) and calls
  [`bin/theme-switch`](bin/theme-switch) on each change. That re-themes running
  tmux and Neovim sessions, btop and Claude Code, and swaps the desktop
  wallpaper (mine are in [devnall/wallpapers](https://github.com/devnall/wallpapers)). It also writes `~/.local/state/appearance`, which zsh
  (syntax highlighting, autosuggestions) and glow read.

NordicPine is [Rosé Pine](https://rosepinetheme.com/) without the heavy use of purple:
pine-green and ice-blue on a near-black background. AlpineDawn is its light
counterpart. The [palette doc](docs/color-palettes.md) has every hex value.

## Borrowing things

Most files stand alone. Copy the one you want and adjust paths that point at
`~/.dotfiles`. Each directory's README says what depends on what.

On a machine I don't own, [`lite-install`](lite-install) puts the shell, tmux
and vim configs in place without sudo, package installs, or anything secret.
It backs up whatever it replaces, and `--uninstall` puts it back:

```sh
git clone https://github.com/devnall/dotfiles ~/dotfiles-lite
~/dotfiles-lite/lite-install          # zsh, bash, tmux, vim: whichever are installed
~/dotfiles-lite/lite-install --uninstall
```

[`bootstrap-stage0`](bootstrap-stage0) is the first step of setting up one of my
own Macs away from home. It's only useful to me as-is, but it's a reasonable
template if you keep private dotfiles behind a VPN (e.g. on a self-hosted forge).

## License

MIT. See [LICENSE](LICENSE).
