# Dotfiles — TODO (Future Phase)

Items that came up during cleanup project planning but are out of scope for the current effort. Add these to your existing dotfiles TODO.md or use this as a standalone tracker.

---

## Rollout & Multi-Machine

- **Bootstrap script / new machine wizard** — Consider a `bootstrap` script (or extending `install`) that handles everything dotbot can't. On a fresh clone, if no marker file exists, it should: prompt the user to choose a machine type (work / personal / remote-full / remote) and create the appropriate marker file; stub out `~/.env.local`, `~/.secrets.local`, and `~/.ssh/config.local` with commented placeholders if they don't already exist; run any other first-time setup steps that are currently manual (git identity check, TPM install, etc.). Goal: `git clone && ./bootstrap` should get a new machine to a fully working state with no additional instructions needed.

## Tool Overhauls

- **Neovim config overhaul** — Separate project. Current config is intentionally stubbed out. Full lazy.nvim setup with LSP, treesitter, keymaps, plugins, etc.
- **Tmux session templates for Claude Code workflows** — Investigate whether tmuxinator or plain tmux session scripts would be useful for spinning up Claude Code working environments (e.g., editor + terminal + logs panes).
- **Tmux sync-panes proper toggle** — `prefix e` / `prefix E` turn sync on/off separately. Make it a single toggle: `bind e run "tmux setw synchronize-panes; tmux display-message 'sync-panes: #{?synchronize-panes,ON,OFF}'"`.
- **Tmux SSH binding tab completion** — `prefix S` opens a prompt to SSH in a new window but has no tab completion. Investigate integrating with known_hosts or fzf for host selection.
- **Tmux TPM as dotbot submodule** — TPM is cloned manually to `~/.tmux/plugins/tpm`. Consider adding it as a git submodule and symlinking via dotbot so it's portable across machines.

## Dotbot

- **Dotbot deep audit and optimization** — Beyond basic cleanup: evaluate whether the submodule update should be automated/scripted, explore dotbot plugins or conditional directives, optimize `install.config.yaml` structure, ensure RUNBOOK maintenance docs are thorough.

## Repo Presentation

- **License and README polish** — If this is a public repo, consider adding a LICENSE file. Polish the README for external readers (not just future-you).

## Git & Hosting

- **Codeberg setup** — If/when you want to try Codeberg for personal projects: add SSH key, host entry in SSH config, any git host-level config. Low effort.
- **GitHub account separation assessment** — Document final decision on single vs separate work/personal GitHub accounts. Current recommendation: stay single-account with `includeIf` path-based identity unless employer requires separation.

## Theming & Appearance

- **Automatic dark/light theme switching** — Implement macOS appearance-change callbacks for tmux, btop, and any other affected tools. Candidate approach: `dark-notify` (keith/formulae) + LaunchAgent. Design holistically across all tools before implementing; alternatively, consider a native polling approach to reduce dependencies.
- **Document theme palettes independently** — Extract color values from shell/tool configs into a standalone reference (or Obsidian note) so they can be reused in other contexts (scripts, web projects, etc.).
- **Custom btop NordicPine theme** — Create a custom btop theme from the NordicPine palette.
- **Ghostty transparency and blur** — Try `background-opacity = 0.90` and window blur in Ghostty config. The old Alacritty config used blur — see if it works well with current themes.
- **Archive dark_nord Ghostty theme** — Save the palette from `config/ghostty/themes/dark_nord` to Obsidian, then delete from the repo (not referenced in Ghostty config).
- **Localize bat rose-pine-dawn theme** — The bat theme is currently fetched via curl in `install.config.yaml`. Try bundling a local copy of the `.tmTheme` file instead and remove the curl step.

## Editors

- **Minimal vim cleanup** — Fix the fallback `vimrc` so it has a usable colorscheme and doesn't throw errors on startup.
- **Neovim alias** — On non-remote machines where neovim is installed, alias it to something convenient. Options: alias `vim` → `nvim` (muscle memory), or use `e` for "edit" if shadowing `vim` feels wrong.

## 1Password & Secrets

- **Learn the `op` CLI** — Figure out the 1Password CLI tool and resolve the recurring permissions popups.
- **Manage ssh.local via 1Password** — Investigate storing per-machine `~/.ssh/config.local` files in 1Password and deploying them with the `op` CLI.
- **Secrets management for env/work.zsh** — Replace hardcoded profile names in `env/work.zsh` with variables; keep real values in a secrets file managed by 1Password CLI. Document the workflow.

## Runtime Management

- **Migrate to mise** — First-class requirement. Scope: python, ruby, rust (currently Homebrew or ad-hoc), tfenv/tenv (terraform), nvm (node), rbenv (ruby). Goal: mise as single source of truth for all language runtimes. Once migrated, remove redundant version managers and Homebrew-managed language packages from Brewfiles.

## Applications

- **Audit installed applications** — On each primary machine (personal desktop, personal laptop, work laptop), audit `/Applications` and `~/Applications`. Sort everything into the universal/work/personal Brewfile pattern. For apps only available via the Mac App Store, either automate with the `mas` CLI or document the manual install steps.

## Shell Utilities

- **Custom tealdeer pages** — Investigate whether tealdeer supports custom/local page overrides for documenting personal aliases and cheatsheet entries alongside community pages.
