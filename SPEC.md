# Dotfiles Project Spec

> **Version:** 7.0
> **Purpose:** Architecture reference and task plan for the `~/.dotfiles` repo. Part A documents design decisions and constraints. Part B holds the **latest** project's task plan — in progress, or the most recently completed. It is overwritten by the next project's first commit, never reset to an idle state on its own (completed plans stay recoverable from this file's git history).
>
> **Repo:** `~/.dotfiles` (Dotbot-managed, macOS/zsh-centric, with Linux remote support)
>
> **Previous:** v6.0 Claude Code settings — install-time layered merge — completed. `bin/claude-settings-build` deep-merges layered source files (`config/claude/settings.{shared,<marker>,local}.json`) into the untracked, real `~/.claude/settings.json`, ending runtime churn and keeping secrets out of the public repo.

---

## Part A: Architecture Reference

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for directory structure,
design decisions, and strict directives.

### Acceptance Criteria

After all cleanup work is complete, these must all be true:

1. `install.config.yaml` successfully symlinks `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs to their correct locations.
2. Shell starts without errors on macOS with zsh.
3. Non-interactive subshells do not emit prompt escape codes or extraneous output.
4. `brew bundle --file=packages/Brewfile.universal` installs cleanly; work/personal Brewfiles install conditionally based on marker file.
5. Neovim opens without blocking errors even when LSPs are absent.
6. `~/.env.local` and `~/.secrets.local` are sourced silently if present, silently skipped if absent.
7. Marker file controls which env config loads correctly for all four marker types; if none exists, only universal config loads.
8. No stale symlinks, no orphaned `install.config.yaml` entries, no references to removed files/directories in documentation.
9. README.md and docs/RUNBOOK.md are accurate and complete reflections of the repo's actual state.
10. Shell startup time is reasonable (benchmark documented).

---

## Part B: Task Plan

### Project: NordicPine dark-mode readability + full-stack palette coherence

**Problem**

Dark-mode `bat` rendered comments as near-invisible dim slate, and `Brewfile.*` files
showed no syntax highlighting at all. Root causes, in the order they surfaced:

1. **No syntax highlighting on `Brewfile.universal/.work/.personal/.local`** — bat maps
   only the exact name `Brewfile` → Ruby; the suffixed variants fell back to plain text,
   so every token (comments included) rendered as the bare foreground. This was the
   actual "comments unreadable" cause — masked because the first screenshot was Neovim,
   not bat.
2. **`bat` dark theme was `base16`**, which borrows the terminal's 16 ANSI colors;
   comments mapped to ANSI bright-black `#343b51`, ~1.7:1 contrast on the `#0f111a` bg.
   `#343b51` does double duty as a structural color (borders, tmux bg), so it could not
   simply be lightened globally.
3. **NordicPine palette had low hue diversity** — palette-4 (blue `#257994`) and
   palette-6 (cyan `#33859d`) were ΔE≈5 apart, collapsing distinct syntax scopes; and the
   bat tmTheme reused one teal across `support.function` / `entity.name.function`.
4. **Neovim treesitter bleed** — rose-pine themes the `@`-capture groups explicitly, so
   the legacy `Function`/`Type`/`Constant` overrides never reached treesitter-highlighted
   code: ~20 semantic groups were rendering rose-pine defaults, not NordicPine.

**Decisions**

- **Keep NordicPine** (test-drove Gotham / Iceberg / Moonfly / Kanagawa Wave; NordicPine
  won the "dark + high text-to-bg contrast + dusty/muted, no purple" brief — Gotham failed
  on contrast not darkness, Moonfly was too vivid). User taste captured in auto-memory
  `theme-color-preferences`.
- bat dark theme = custom `config/bat/themes/nordicpine.tmTheme` (mirrors light-mode
  `rose-pine-dawn.tmTheme`); every color traces to `docs/color-palettes.md`.
- Comments = Autosuggest `#555e7a` everywhere (readable, palette-faithful); `#343b51`
  retired to structural-only (borders / invisibles).
- palette-4 `#257994 → #2a5f8f` (blue ≠ cyan, ΔE 5 → 23) across all role usages.
- Light mode stays clean Rosé Pine Dawn / AlpineDawn — dark overrides must fully toggle off.

**Tasks**

- [x] **bat syntax mapping** — `--map-syntax "Brewfile.*:Ruby"` in `config/bat/config`.
- [x] **bat dark theme** — new `nordicpine.tmTheme`; `--theme-dark="nordicpine"`; symlink
      entry in `install.config.yaml`; `bat cache --build`. Builtins (`support.function`)
      → blue, user functions teal; readable `gutterForeground` + pink grid.
- [x] **Palette blue/cyan split** — palette-4 → `#2a5f8f` in `ghostty/themes/NordicPine`,
      `color-palettes.md`, `starship.toml` ×2, `tmux-nordic.conf`. palette-8
      `#343b51 → #555e7a` (Ghostty + doc ANSI table).
- [x] **Readable comments across the stack** — `#343b51 → #555e7a` in nvim
      `appearance.lua`, `vim/colors/nordicpine.vim`, `zsh/lib/theme.zsh`.
- [x] **nvim treesitter alignment** — ~20 `@`-groups mapped onto the NordicPine palette in
      `appearance.lua` (functions teal + builtins blue, types cyan, constants gold,
      variables fg, `self`/labels pink, tags blue, punctuation slate).
- [x] **Doc sync** — `color-palettes.md`: ANSI-8 → `#555e7a`; relabel `#343b51`
      (borders/invisibles) and `#555e7a` (autosuggest/comments).

**Status:** Implemented on branch `feat/nordicpine-dark-readability`. Verified live: bat
renders Brewfiles with readable comments and builtin ≠ user-function colors; nvim dark
mode is full NordicPine across legacy + treesitter groups. A headless `dark → light →
dark` toggle confirms every override clears to clean Rosé Pine Dawn and restores with no
leakage in either direction; ΔE math confirms the blue/cyan separation (5 → 23). Shipped
as a 3-commit split: `🔧` drop deprecated `docker-completion` (pre-existing working-tree
change) + `🐛` Brewfile.* map-syntax + `🎨` NordicPine dark-mode overhaul.

**Acceptance**

- bat dark mode: `Brewfile.*` highlight; comments legible (`#555e7a`, ~2.9:1);
  builtins ≠ user functions.
- nvim: dark = NordicPine across legacy + treesitter; light = clean Rosé Pine Dawn; the
  dark↔light toggle is lossless in both directions.
- NordicPine 16-color palette has no near-duplicate slots (blue ≠ cyan, ΔE ≥ ~20).
- All theme colors trace to `docs/color-palettes.md`.
