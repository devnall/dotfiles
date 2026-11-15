# zsh

`zshrc.zsh` (linked to `~/.zshrc`) stays small: history, directory stack, the
plugin manager, and the prompt. Everything else lives in `lib/`, one file per
concern, linked to `~/.config/zsh/lib/` and sourced **alphabetically**, so the
file name is the load order.

| File | What it does |
|---|---|
| `lib/aliases.zsh` | General aliases. Standard commands (`ls`, `cat`, `grep`) are never redefined; replacements get new names: `l`, `ll`, `la`, `lt` use eza when it's installed and fall back to `ls`. |
| `lib/git.zsh` | Short git aliases (`gst`, `gco`, `glog`, …). Where [forgit](https://github.com/wfxr/forgit) isn't loaded, plain-git versions of its aliases (`ga`, `glo`, …) take over. |
| `lib/fzf.zsh` | fzf keybindings and completion, with `fd` and `bat` previews |
| `lib/completions.zsh` | Completion setup, including cached 1Password CLI completions (no prompt on every shell start) |
| `lib/keybindings.zsh` | Up/Down search history for lines starting with what you've typed |
| `lib/directory_nav.zsh` | Typing `...` expands to `../..` as you type (and so on for each extra dot) |
| `lib/theme.zsh` | Syntax-highlighting and autosuggestion colors that follow the dark/light state file |
| `lib/path.zsh`, `lib/brew.zsh` | PATH and Homebrew helpers |
| `lib/ssh.zsh` | 1Password's SSH agent on macOS, a persistent `ssh-agent` on Linux |
| `zfunctions/` | `clipboard`, `color_list`, and a fallback prompt for machines without Starship |

**Plugins** come from [sheldon](https://github.com/rossmacarthur/sheldon)
([`config/sheldon/plugins.toml`](../config/sheldon/plugins.toml)):
fast-syntax-highlighting, zsh-autosuggestions, forgit, zsh-you-should-use, and
oh-my-zsh's `colored-man-pages` and `extract` plugins.

**Guards worth copying:**
- Prompt setup runs only in interactive shells (`[[ $- == *i* ]]`).
- Anything that needs the line editor, such as plugins, fzf and completions,
  runs only with a terminal attached (`[[ -t 1 ]]`).
- Together these keep scripts, `ssh host cmd` and editor subshells fast and free
  of escape codes.

**Not included:** `zshrc` sources per-machine files (`env/work.zsh`,
`env/personal.zsh`, …) chosen by a marker file such as `~/.work`, then
`~/.env.local` and `~/.secrets.local`. Those stay private; the `[[ -f ]]` checks
skip them when they're missing.
