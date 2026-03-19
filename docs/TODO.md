# Dotfiles — TODO

Deferred ideas and future improvements.

---

## Tool Overhauls

- **Neovim config overhaul** — Separate project. Current config is intentionally stubbed out. Full lazy.nvim setup with LSP, treesitter, keymaps, plugins, etc. **Note:** vim-tmux-navigator plugin is installed in tmux and works between tmux panes, but integration with neovim panes requires the neovim counterpart plugin — defer full setup to neovim overhaul.

## Dotbot

- **Dotbot deep audit and optimization** — Beyond basic cleanup: evaluate whether the submodule update should be automated/scripted, explore dotbot plugins or conditional directives, optimize `install.config.yaml` structure, ensure RUNBOOK maintenance docs are thorough.

## Repo Presentation

- **License and README polish** — If this is a public repo, consider adding a LICENSE file. Polish the README for external readers (not just future-you).

## CI / Repo Health

- **GitHub Actions + pre-commit scaffolding** — Set up lightweight repo automation: config file linting (YAML, TOML, shell via `shellcheck`), a pre-commit hook for basic sanity checks (trailing whitespace, syntax), and a simple GitHub Actions workflow to run the same checks on push/PR. Keep it minimal — no baroque pipelines, just a safety net that catches obvious mistakes before they land.

# Applications

- **Audit installed applications** — On each primary machine (personal desktop, personal laptop, work laptop), audit `/Applications` and `~/Applications`. Sort everything into the universal/work/personal Brewfile pattern. For apps only available via the Mac App Store, either automate with the `mas` CLI or document the manual install steps.

## Shell Utilities

- ~~**Custom tealdeer pages**~~ — Done. Custom pages in `docs/tldr/common/my-*.md`, symlinked via dotbot. `cheat.sh` provides fzf-powered browsing of full cheatsheets.

## Performance

- **Shell startup time audit** — Benchmark shell startup time on all primary machines (personal desktop, personal laptop, work laptop) using the RUNBOOK method. Target is under ~500ms warm. One laptop is currently 590–690ms after the mise migration. Profile with `zsh -x` or `zprof` to identify the slowest contributors and optimize if needed. **This should be one of the last TODOs worked from this list** — let other changes land first so the audit captures the final steady-state.

## Someday / Maybe

- **macOS defaults & OS customization** — Revisit `defaults write` settings for new machines: Dock config (auto-hide, icon size, remove default apps), keyboard repeat rate, trackpad settings, Finder preferences, screenshot location, etc. Consider reintroducing `config/macos/` with a `defaults.sh` script that bootstrap or install can call on macOS.
- **Codeberg setup** — If/when you want to try Codeberg for personal projects: add SSH key, host entry in SSH config, any git host-level config. Low effort.
