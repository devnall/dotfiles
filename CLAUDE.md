# CLAUDE.md

## Repo overview

Dotbot-managed dotfiles repo. macOS/zsh-centric, with minimal Linux remote support. See `docs/ARCHITECTURE.md` for full design decisions and `docs/RUNBOOK.md` for operational reference.

## Workflow conventions

- **Branching:** Always create a new branch (or worktree) before making changes. Never commit directly to master or main.
- **Commit messages:** Use gitmoji-style prefixes per https://gitmoji.dev. Common: ✨ feature, 🐛 fix, 🚚 move/rename, 🔧 config, ♻️ refactor, 🔥 remove, 📝 docs, 🧹 cleanup.
- **Symlinks:** All symlinks are managed by dotbot via `install.config.yaml`. To symlink a new file, add an entry to the `link:` block and run `./install`. Never use `ln -s` directly.

## Shell directives

These must be respected when editing any shell config:

1. **Interactive shell guards** — Wrap prompt/theme init (starship, prompt fallbacks) with `[[ $- == *i* ]]`. Wrap ZLE-dependent code (sheldon, fzf, completions) with `[[ -t 1 ]]`. Aliases, exports, and PATH do NOT need guards.
2. **POSIX alias safety** — Do not alias standard POSIX commands (`ls`, `cat`, `grep`) to alter their output. Use new names (e.g., `ll` for `eza -l`).
3. **Git config simplicity** — No exotic git hooks or `core.editor` behaviors that break automated commit workflows.

## Key paths

| Path | Purpose |
|------|---------|
| `install.config.yaml` | Dotbot config — all symlinks and shell commands |
| `zsh/zshrc.zsh` | Zsh entrypoint (symlinked to `~/.zshrc`) |
| `zsh/lib/` | Modular zsh config, auto-sourced alphabetically |
| `config/` | Tool configs symlinked to `~/.config/` |
| `packages/Brewfile.*` | Homebrew packages (universal, work, personal) |
| `docs/ARCHITECTURE.md` | Design source of truth |
| `docs/RUNBOOK.md` | Usage, maintenance, troubleshooting |
| `docs/TODO.md` | Deferred ideas and future work |
| `SPEC.md` | Current project task plan (rotates per project) |
