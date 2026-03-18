# Dotfiles — TODO

Deferred ideas and future improvements.

---

## Rollout & Multi-Machine

- **Bootstrap script / new machine wizard** — Consider a `bootstrap` script (or extending `install`) that handles everything dotbot can't. On a fresh clone, if no marker file exists, it should: prompt the user to choose a machine type (work / personal / remote-full / remote) and create the appropriate marker file; stub out `~/.env.local`, `~/.secrets.local`, and `~/.ssh/config.local` with commented placeholders if they don't already exist; run any other first-time setup steps that are currently manual (git identity check, TPM install, etc.). Goal: `git clone && ./bootstrap` should get a new machine to a fully working state with no additional instructions needed.

## Tool Overhauls

- **Neovim config overhaul** — Separate project. Current config is intentionally stubbed out. Full lazy.nvim setup with LSP, treesitter, keymaps, plugins, etc. **Note:** vim-tmux-navigator plugin is installed in tmux and works between tmux panes, but integration with neovim panes requires the neovim counterpart plugin — defer full setup to neovim overhaul.
- **Tmux session templates for Claude Code workflows** — Investigate whether tmuxinator or plain tmux session scripts would be useful for spinning up Claude Code working environments (e.g., editor + terminal + logs panes).

## Dotbot

- **Dotbot deep audit and optimization** — Beyond basic cleanup: evaluate whether the submodule update should be automated/scripted, explore dotbot plugins or conditional directives, optimize `install.config.yaml` structure, ensure RUNBOOK maintenance docs are thorough.

## Repo Presentation

- **License and README polish** — If this is a public repo, consider adding a LICENSE file. Polish the README for external readers (not just future-you).

## Git & Hosting

- **Commit signing across all machines** — Done on main desktop (`commit.gpgsign = true`, `gpg.format = ssh`, `user.signingkey` configured). Still needs to be set up on both laptops (work + personal). Configure `user.signingkey` in each machine's `.gitconfig-user`. Coordinate with the 1Password `op` CLI setup to use 1Password-managed SSH keys for signing.
- **Codeberg setup** — If/when you want to try Codeberg for personal projects: add SSH key, host entry in SSH config, any git host-level config. Low effort.
- **GitHub account separation assessment** — Document final decision on single vs separate work/personal GitHub accounts. Current recommendation: stay single-account with `includeIf` path-based identity unless employer requires separation.

## Theming & Appearance

- **Ghostty transparency and blur** — ~~Evaluated~~ Rejected. Marginally preferred in light mode (AlpineDawn), but not in dark mode (NordicPine), and not worth the complexity of per-theme switching. Commented-out block left in `config/ghostty/config` for easy future experimentation.

_Done: palette reference doc (`docs/color-palettes.md`), btop NordicPine theme, dark\_nord archived and removed._


## Editors

- **Minimal vim cleanup** — Fix the fallback `vimrc` so it has a usable colorscheme and doesn't throw errors on startup.
- **Neovim alias** — On non-remote machines where neovim is installed, alias it to something convenient. Options: alias `vim` → `nvim` (muscle memory), or use `e` for "edit" if shadowing `vim` feels wrong.

## 1Password & Secrets

- **Learn the `op` CLI** — Figure out the 1Password CLI tool and resolve the recurring permissions popups.
- **Manage ssh.local via 1Password** — Investigate storing per-machine `~/.ssh/config.local` files in 1Password and deploying them with the `op` CLI.
- **Secrets management for env/work.zsh** — Replace hardcoded profile names in `env/work.zsh` with variables; keep real values in a secrets file managed by 1Password CLI. Document the workflow.

## Applications

- **Audit installed applications** — On each primary machine (personal desktop, personal laptop, work laptop), audit `/Applications` and `~/Applications`. Sort everything into the universal/work/personal Brewfile pattern. For apps only available via the Mac App Store, either automate with the `mas` CLI or document the manual install steps.

## Shell Utilities

- **Custom tealdeer pages** — Investigate whether tealdeer supports custom/local page overrides for documenting personal aliases and cheatsheet entries alongside community pages.

## Performance

- **Shell startup time audit** — Benchmark shell startup time on all primary machines (personal desktop, personal laptop, work laptop) using the RUNBOOK method. Target is under ~500ms warm. One laptop is currently 590–690ms after the mise migration. Profile with `zsh -x` or `zprof` to identify the slowest contributors and optimize if needed. **This should be one of the last TODOs worked from this list** — let other changes land first so the audit captures the final steady-state.
