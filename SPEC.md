# Dotfiles Cleanup & Improvement Spec

> **Version:** 3.0
> **Purpose:** Comprehensive spec for Claude Code to execute a cleanup, audit, and improvement pass on the `~/.dotfiles` repo. Contains both the architectural reference (design decisions, directives, acceptance criteria) and the sequenced task plan.
>
> **Repo:** `~/.dotfiles` (Dotbot-managed, macOS/zsh-centric, with Linux remote support)
>
> **Working branch:** Create a dedicated branch for this work. Commit incrementally per-task.

---

## Part A: Architecture Reference

This section documents the repo's design decisions, constraints, and acceptance criteria. It is context for the task plan in Part B — Claude Code should understand and respect these decisions when executing tasks.

### A.1 Directory Structure

```text
dotfiles/
├── .git/
├── .gitignore
├── ARCHITECTURE.md           # Design reference (authoritative)
├── SPEC.md                   # Current project task plan
├── TODO.md                   # Deferred ideas and future work
├── README.md                 # Quick-start guide
├── RUNBOOK.md                # Detailed usage and maintenance reference
├── dotbot/                   # Git submodule
├── install.config.yaml       # Dotbot config
├── install                   # Dotbot bootstrap script
├── bin/                      # Global shell scripts (all symlinked to ~/bin)
├── docs/                     # Cheatsheets (fzf, tmux, git, shell, kubernetes)
├── zsh/
│   ├── zshrc.zsh             # Entrypoint (symlinked to ~/.zshrc)
│   ├── lib/                  # Modular zsh config files (auto-sourced alphabetically)
│   │   ├── aliases.zsh
│   │   ├── brew.zsh
│   │   ├── completions.zsh
│   │   ├── directory_nav.zsh
│   │   ├── fzf.zsh
│   │   ├── git.zsh
│   │   ├── keybindings.zsh
│   │   ├── local.zsh.template  # Template — copy to local.zsh for per-machine shortcuts
│   │   ├── path.zsh
│   │   ├── ssh.zsh
│   │   └── theme.zsh           # fast-syntax-highlighting styles
│   └── zfunctions/           # Autoloaded zsh functions
├── env/
│   ├── work.zsh              # Sourced when ~/.work exists
│   ├── personal.zsh          # Sourced when ~/.personal exists
│   ├── remote.zsh            # Sourced when ~/.remote exists
│   └── remote-full.zsh       # Sourced when ~/.remote-full exists
├── packages/
│   ├── Brewfile.universal    # Installed on all machines
│   ├── Brewfile.work         # Installed on work machines only
│   └── Brewfile.personal     # Installed on personal machines only
└── config/                   # XDG-style tool configs
    ├── bash/bashrc           # Minimal bash (remote server baseline only)
    ├── bat/
    ├── btop/
    ├── ghostty/
    ├── git/
    ├── macos/                # macOS setup scripts
    ├── nvim/                 # Neovim config (lazy.nvim)
    ├── ripgrep/
    ├── sheldon/              # Zsh plugin manager config
    ├── ssh/                  # SSH config template (private hosts in ~/.ssh/config.local)
    ├── starship/
    ├── tmux/
    └── vim/vimrc             # Minimal vim fallback (no plugins, remote-safe)
```

### A.2 Core Design Decisions

#### Configuration Management (Dotbot)
- `dotbot` handles all symlinking and bootstrapping via `install.config.yaml`.
- The `install` script must be 100% idempotent — safe to re-run at any time without errors or duplications.
- `install.config.yaml` symlinks at minimum: `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs under `config/` to their correct XDG locations.

#### Shell Environment
- **Primary:** macOS with zsh. Only fully-supported interactive shell environment.
- **Remote baseline:** `config/bash/bashrc` provides a minimal `.bashrc` for remote servers — PATH, essential aliases only. No visual elements, does not mirror the full zsh setup.
- **Entrypoint:** `zsh/zshrc.zsh` is the sole zsh entrypoint. It sources `zsh/lib/*.zsh` directly — no `shell/`, `os/`, or `env/` module tree.
- **Plugin manager:** Sheldon (`config/sheldon/`) manages zsh plugins. Homebrew dependency. Initialization guarded with `command -v sheldon > /dev/null`.

#### Machine-Specific PATH
- **Universal toolchain paths** (Homebrew, Cargo, Go, Ruby gems): defined in `zsh/lib/path.zsh`, guarded with `[[ -d /path ]]` checks.
- **Machine-specific tools** (e.g., LM Studio, Claude Code): go in `~/.env.local`, NOT committed to the repo.

#### Environment Separation (Marker Files)
- **Detection:** Marker file approach — one of `~/.work`, `~/.personal`, `~/.remote-full`, or `~/.remote` is touched during machine setup. No hostname detection.
- **Shell loader:** Sources the corresponding `env/*.zsh` file. If no marker exists, only universal config loads.
- **Dotbot install:** Runs `brew bundle` for the appropriate Brewfile(s) based on marker.
- **Marker definitions:**
  - `~/.work` — work machine (full macOS setup)
  - `~/.personal` — personal machine (full macOS setup)
  - `~/.remote-full` — Linux server with Homebrew and full tool suite
  - `~/.remote` — minimal Linux server (no Homebrew; skips Brewfiles entirely)

#### Secrets Management
- Passwords, API keys, and tokens MUST NOT be committed to version control.
- `.gitignore` must explicitly exclude `*.local`, `.env*`, `*secrets*`, and `*.key`.
- **Local override files** (both gitignored, sourced silently, skipped without error if absent):
  - `~/.env.local` — machine-specific exports, PATH additions, non-secret config
  - `~/.secrets.local` — credentials, API keys, tokens
- **Sourcing order:** `~/.env.local` first, then `~/.secrets.local` at the very end of `zshrc.zsh`.

#### Editor Configuration
- **Neovim** (`config/nvim/`): lazy.nvim-based. Intended for desktop machines. Must open without blocking errors when an LSP or external tool is missing. Full overhaul is a **separate project** — current cleanup is light-touch only.
- **Vim** (`config/vim/vimrc`): Must work on any remote server with stock vim and zero external dependencies. Sensible defaults only.

### A.3 Strict Directives

These directives must be respected during all cleanup and audit work:

1. **Interactive Shell Guards** — Guard only prompt/theme initialization behind `[[ $- == *i* ]]`. Specifically: `eval "$(starship init zsh)"` and custom prompt fallbacks MUST be wrapped. Aliases, exports, and PATH additions do NOT need wrapping (inert in non-interactive contexts). Rationale: prevents Starship escape codes from leaking into piped output from non-interactive subshells.

2. **POSIX Alias Safety** — Do NOT alias standard POSIX commands (`ls`, `cat`, `grep`) in ways that alter their default machine-readable output. Use new alias names instead (e.g., `ll` for `eza -l`, not `ls`).

3. **Git Config Simplicity** — Do not implement exotic Git hooks or `core.editor` behaviors that interrupt standard automated commit workflows.

### A.4 Acceptance Criteria

After all cleanup work is complete, these must all be true:

1. `install.config.yaml` successfully symlinks `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs to their correct locations.
2. Shell starts without errors on macOS with zsh.
3. Non-interactive subshells do not emit prompt escape codes or extraneous output.
4. `brew bundle --file=packages/Brewfile.universal` installs cleanly; work/personal Brewfiles install conditionally based on marker file.
5. Neovim opens without blocking errors even when LSPs are absent.
6. `~/.env.local` and `~/.secrets.local` are sourced silently if present, silently skipped if absent.
7. Marker file controls which env config loads correctly for all four marker types; if none exists, only universal config loads.
8. No stale symlinks, no orphaned `install.config.yaml` entries, no references to removed files/directories in documentation.
9. README.md and RUNBOOK.md are accurate and complete reflections of the repo's actual state.
10. Shell startup time is reasonable (benchmark documented).

---

## Part B: Task Plan

Organized into sequential phases with dependencies noted. Each task is tagged as **Claude Code**, **Human**, or **Collaborative**.

### Phase 0: Setup & Discovery

Before changing anything, gather a complete picture of the repo's current state.

#### 0.1 — Full repo inventory
**Type:** Claude Code

Produce a complete file tree of the repo (excluding `.git/`). This is the reference for all subsequent tasks. Save the output for diffing against documentation.

#### 0.2 — Diff repo state against docs
**Type:** Claude Code → human review for ambiguous items

Compare the actual repo tree against:
- The directory structure documented in RUNBOOK.md and this spec (Section A.1)
- The tool list in the README.md intro
- The `zsh/lib/` file list in the RUNBOOK
- The `config/` subdirectories mentioned in docs

Produce a discrepancy report:
- Files/directories that exist but aren't documented
- Files/directories documented but don't exist
- Tool names mentioned in README that don't have corresponding config
- Anything else out of sync

Items requiring human judgment go to the **Human Review Checklist**.

---

### Phase 1: Remove Cruft

Clear out things that shouldn't be in the repo before auditing what remains.

#### 1.1 — Archive inventory and cleanup
**Type:** Collaborative (Claude Code inventories → human decides → Claude Code executes)

**Steps:**
1. List every file and directory in `archive/`. For each, provide:
   - Filename and type
   - Summary of contents/purpose
   - Recommendation: delete, relocate, or flag for human review
2. Special handling:
   - **archive/bash/** — Cross-reference against `config/bash/bashrc` and zsh aliases. Flag any aliases, functions, or settings worth pulling forward into the remote bash baseline or zsh config.
   - **archive/remote/ + TODO file** — Read the TODO, surface anything still relevant as potential new tasks.
   - **Scripts (bash, .scpt)** — Summarize what each does, assess relevance. AppleScript is macOS-specific and might still be useful in `bin/`.
   - **Prompt configs** — Likely superseded by Starship. Confirm.
   - **devnall.theme** — Identify what tool it's for. If it's a color palette, output the values for preservation.
   - **svmrc** — Identify what `svm` is and whether it's still relevant.
   - **tmuxinator.yaml** — Preserve the workspace layout concept. Output contents for reference. (Tmux session templates are a future TODO item.)
3. Human makes keep/kill/relocate decisions on each item.
4. Claude Code executes decisions, removes `archive/` directory entirely.
5. Remove all `archive/` references from `install.config.yaml`, README, and RUNBOOK.

#### 1.2 — Purge obsolete terminal configs
**Type:** Claude Code → human confirms

Examine `config/alacritty/` and `config/iTerm2.prefs/`:
- Summarize what's in each (color schemes, keybindings, notable settings)
- Flag anything worth preserving (e.g., color values to carry into Ghostty config)
- Output any preserved content as markdown for the human to save

After human confirmation:
- Delete both directories
- Remove corresponding entries from `install.config.yaml`
- Remove any references in docs

#### 1.3 — Deal with stray docker-compose.yml
**Type:** Human decision

Surface the contents of the docker-compose.yml in `config/`. Likely homelab config that doesn't belong in dotfiles. Human decides: move to separate repo, save to Obsidian, or delete. Add to **Human Review Checklist**.

---

### Phase 2: Structural Cleanup

Address organizational issues in the repo structure.

#### 2.1 — Investigate and resolve `zsh/lib/work.zsh` loading exception
**Type:** Claude Code investigates → human decides

1. Examine the contents of both `zsh/lib/work.zsh` and `env/work.zsh`
2. Document the exclusion logic in `zshrc.zsh` that skips `zsh/lib/work.zsh` from auto-sourcing
3. Assess overlap and separation between the two files
4. Recommend one of:
   - **Merge** `zsh/lib/work.zsh` into `env/work.zsh` (preferred if no good reason for separation)
   - **Move** it out of `lib/` to a location that doesn't imply auto-sourcing
   - **Leave it** with clear documentation and rationale
5. If the fix is straightforward and human approves, execute it

**Note:** Respect Directive A.3.1 (interactive shell guards) and A.3.2 (POSIX alias safety) when evaluating any shell config changes.

#### 2.2 — `install.config.yaml` consistency check
**Type:** Claude Code

Cross-reference in both directions:
- Every directory under `config/` should have a corresponding symlink entry
- Every symlink entry should point to something that exists
- `bin/` glob-symlink is correct
- No stale or orphaned entries
- Flag any entries that seem misconfigured

This runs throughout the project but gets an explicit check here.

---

### Phase 3: Audit & Improve — Shell Config

#### 3.1 — Zsh config audit
**Type:** Claude Code → human review for subjective items

Thorough pass through `zsh/zshrc.zsh`, all files in `zsh/lib/`, and all functions in `zsh/zfunctions/`:

- **TODOs/FIXMEs** — Grep for `TODO`, `FIXME`, `HACK`, `XXX`, `NOTE` comments. Surface all.
- **Dead code** — Commented-out blocks, aliases referencing tools no longer in use, unreachable logic.
- **Conflicts** — Duplicate PATH entries, contradictory shell options, aliases that shadow each other or built-in commands.
- **Optimizations** — Lazy loading opportunities, unnecessary evals at startup, redundant `command -v` checks, anything slowing shell init.
- **Guard consistency** — All `command -v` / `uname` guards follow a consistent pattern. Verify interactive shell guards per Directive A.3.1.
- **POSIX alias safety** — Verify compliance with Directive A.3.2.
- **Structure** — Does the file breakdown in `lib/` still make sense? Are things in the right files? Could any files be merged or split?
- **zfunctions** — Properly autoloaded? Still useful? Documented?

Subjective items (e.g., "is this alias useful to you?") go to **Human Review Checklist**.

#### 3.2 — Review env/ files
**Type:** Human task

Claude Code surfaces the contents of `env/personal.zsh`, `env/work.zsh`, `env/remote.zsh`, and `env/remote-full.zsh` for human review. Human verifies each is correct and contains what's expected.

*Depends on:* 2.1 (work.zsh resolution) should be decided first.

**Note for 3.3:** `zsh/lib/history.zsh` only contains history-substring-search keybindings — the actual history settings (HISTFILE, HISTSIZE, setopt) live in `zshrc.zsh`. Consider whether the keybindings belong here or should move into the Sheldon plugin definition for history-substring-search, since the keybindings are meaningless without that plugin.

#### 3.3 — Sheldon plugin reconciliation
**Type:** Claude Code → human review

After the zsh audit (3.1), cross-reference Sheldon's plugin list against what's actually used in the zsh config:
- Plugins loaded but never referenced
- Plugins redundant with native zsh config or other plugins
- Plugins that might be worth adding based on observed patterns

Human decides what to keep/remove.

---

### Phase 4: Audit & Improve — Git Config

#### 4.1 — Git config audit and cleanup
**Type:** Claude Code → human review

**Repo-level git housekeeping:**
- Audit `.gitignore` — patterns tight, nothing missing, nothing stale
- Audit `.gitmodules` — clean, just dotbot
- Check for `.git/` cruft

**Global git config review (`config/git/`):**
- Check all settings against current best practices (default branch naming, pull strategy, fsmonitor, credential helpers, diff/merge tools, signing config, aliases)
- Respect Directive A.3.3 (git config simplicity)
- Assess global vs local split — what should vary by machine?

**Work/personal identity separation:**
- Set up `includeIf` path-based conditional includes (e.g., repos under `~/work/` get work email/signing key)
- Document the convention

**Codeberg readiness (optional, can defer to TODO):**
- Add SSH config entry and host-level git config so Codeberg works if/when adopted

**Account separation assessment:**
- Document tradeoffs of single vs separate GitHub accounts
- Recommendation: stay single-account with `includeIf` unless compelling reason
- Surface to human for final call

#### 4.2 — SSH config review (security-conscious)
**Type:** Collaborative — Claude Code assesses, human decides

**⚠️ Security first.** Careful consideration of what ends up in a public repo.

1. Examine current SSH config situation — what exists in `zsh/lib/ssh.zsh`, what's in `~/.ssh/config` (if anything)
2. Assess whether any SSH config should be repo-managed. Options:
   - **Fully managed** with sensitive hosts in a gitignored `~/.ssh/config.local` include
   - **Template only** — repo has a documented pattern, actual config stays local
   - **Documentation only** — RUNBOOK describes the recommended setup, nothing in repo
3. **Non-negotiable: no hostnames, IPs, usernames, or key paths for private infrastructure in the public repo**
4. Connects to Codeberg setup if adding a new host

Human makes the final architecture decision.

---

### Phase 5: Audit & Improve — Tool Configs

#### 5.1 — Config directory tool-by-tool audit
**Type:** Claude Code per-tool → human review for preferences

Go through each config directory one at a time. For each, check: no cruft, no conflicts, settings follow current best practices, themes are intentional.

**Pre-audit cleanup:**
- Delete `config/alacritty/` (the `alacritty.toml` kept from Phase 1.2 as a reference). Cross-check any relevant settings against Ghostty config first, then `git rm -r config/alacritty/`.

**Tools to audit:**
- **bat** — config, themes, syntax mappings
- **btop** — theme, layout, custom settings
- **ghostty** — terminal config, keybindings, font/color settings
- **nvim** — **Light touch only.** Verify no broken plugin refs, no errors on launch, config is clean for what's there. Full overhaul is a separate project.
- **ripgrep** — likely just `.ripgreprc`, quick check
- **sheldon** — verify config file itself is clean (plugin decisions covered in 3.3)
- **starship** — prompt modules match tools actually installed, no stale module configs
- **tmux** — keybindings, theme, plugins, prefix key, integrations
- **vim** — minimal fallback config, verify it's truly minimal and functional per Section A.2

Also check:
- **`config/bash/bashrc`** — minimal remote baseline, verify it's clean (informed by archive/bash review from 1.1)
- **`config/macos/`** — defaults scripts still valid on current macOS? Still desired? (Connects to 6.2)

#### 5.2 — bin/ scripts audit
**Type:** Claude Code inventories → human decides

For each script in `bin/`:
- Summarize purpose
- Check for overlap with aliases or zsh functions
- Assess code quality (shellcheck if bash)
- Flag anything stale or unused

Human decides what to keep, rewrite, or remove.

---

### Phase 6: Documentation

#### 6.1 — Update README with remote/remote-full markers
**Type:** Claude Code

Add installation instructions for `~/.remote` and `~/.remote-full` marker files to the README's Install section. All four marker types should be clearly documented in both README and RUNBOOK.

#### 6.2 — Diff `new_mac_setup.md` against RUNBOOK
**Type:** Claude Code → human decides on file's fate

1. Compare `docs/new_mac_setup.md` with the RUNBOOK's "New Machine Setup" section
2. Pull anything useful from the standalone doc into the RUNBOOK
3. Pull anything useful from the RUNBOOK into the standalone doc
4. RUNBOOK becomes the authoritative source for dotfiles-related setup
5. If `new_mac_setup.md` has non-dotfiles content (System Settings, app preferences), it survives as a separate doc
6. Human decides where that file ultimately lives (repo, Obsidian, etc.)

*Connects to:* 5.1 `config/macos/` audit — macOS defaults scripts and new_mac_setup doc likely overlap.

#### 6.3 — Docs/ cheatsheet audit and update
**Type:** Collaborative (one cheatsheet at a time)

For each of the ~8 cheatsheets in `docs/`:
1. Identify which tool it covers
2. Is the tool still in use? (Human confirms)
3. **If no longer used:** Output clean markdown for human to paste into Obsidian. Add to **Human Review Checklist** ("copy to Obsidian then confirm deletion"). Delete after confirmation.
4. **If still in use:** Collaborative update:
   - Cross-reference against actual config (aliases, keybindings, functions) elsewhere in the repo
   - Flag anything outdated or incorrect
   - Suggest additions based on the user's actual workflows and customizations — NOT comprehensive man-page documentation
   - Human reviews and adjusts before finalizing

**Do these one at a time, not in batch.**

#### 6.4 — `StuffIUse.md` disposition
**Type:** Human decision

Surface contents, human decides where it goes. Likely candidate for Obsidian. Add to **Human Review Checklist**.

#### 6.5 — Comprehensive RUNBOOK and README update
**Type:** Claude Code (final pass)

After all other tasks are complete, do a final pass on both docs:
- All four marker types documented in both files
- Directory tree in RUNBOOK matches actual post-cleanup state
- Maintenance section is comprehensive (Homebrew, dotbot, plugins, shell startup benchmark, Brewfile drift, Neovim sync, etc.)
- All references to removed items (archive/, alacritty, iTerm2, etc.) are gone
- No stale tool names or file paths
- Consistent style and formatting

Also update the directory structure in Section A.1 of this SPEC to reflect post-cleanup state.

---

### Phase 7: Final Verification

#### 7.1 — Dotbot cleanup and verification
**Type:** Claude Code

- Verify `install.config.yaml` is clean and consistent after all changes
- Check dotbot submodule is pointing to a reasonable commit
- Run `./install` and verify it completes without errors
- Check for orphaned symlinks on disk

#### 7.2 — Shell startup time benchmark
**Type:** Claude Code

Run `time zsh -i -c exit` multiple times to get a baseline. If startup is slow (> ~200ms), use `zsh -xv` or `zprof` to trace slow spots and optimize. Document the final benchmark in the RUNBOOK's maintenance section as a reference number.

#### 7.3 — Reconcile and retire `config/macos/Brewfile`
**Type:** Collaborative

`config/macos/Brewfile` is the old unified Brewfile, predating the universal/work/personal split. It must be fully reconciled before deletion.

1. Diff every entry in `config/macos/Brewfile` against `Brewfile.universal`, `Brewfile.work`, and `Brewfile.personal`
2. Identify any entries not present in any of the three new Brewfiles
3. Surface the gaps to the human with a recommendation for each (universal / work / personal / skip)
4. Human decides placement for each gap item
5. Claude Code updates the appropriate Brewfile(s)
6. Delete `config/macos/Brewfile` once fully reconciled

#### 7.4 — Brewfile audit (current machine only)
**Type:** Collaborative

On the current machine:
1. Run `brew leaves`, `brew list --cask`, `brew bundle dump`
2. Diff against `Brewfile.universal` and the appropriate machine-type Brewfile
3. Identify:
   - Installed but not tracked
   - Tracked but potentially unwanted
   - Apps in `/Applications` that could be cask-managed
4. Human makes placement decisions (universal / work / personal / don't track)
5. Claude Code updates Brewfiles

**Note:** Cross-machine reconciliation is a rollout-phase task (see TODO.md). This pass covers the current machine only.

#### 7.5 — Run acceptance criteria
**Type:** Claude Code

Verify all acceptance criteria from Section A.4 are met. Document results.

#### 7.6 — Final commit and summary
**Type:** Claude Code

- Ensure all changes are committed with clear messages
- Produce a summary of everything that was done
- Confirm TODO.md and Human Review Checklist are complete

---

### Phase 8: Rollout (Post-Cleanup)

These tasks happen after the main cleanup is complete. See `TODO.md` for the full future-phase list.

- Clone updated repo on all other machines and test
- Run `./install` on each and verify
- Pull in any useful local customizations from each machine
- Complete cross-machine Brewfile reconciliation
- Final multi-machine verification of acceptance criteria

---

## Appendix: Human Review Checklist

Populated during execution. Items are added whenever a task surfaces something requiring human judgment.

**Template entries (expanded during execution):**

- [x] Archive file-by-file keep/kill/relocate decisions (1.1) — archive/ cleared entirely
- [x] Confirm nothing worth saving in alacritty/iTerm2 configs (1.2) — alacritty.toml kept as Phase 5.1 reference; all themes/colors and iTerm2 plist deleted
- [x] Decide where docker-compose.yml goes (1.3) — scrubbed from git history entirely
- [x] Approve `zsh/lib/work.zsh` resolution (2.1) — useful content migrated to env/work.zsh; file deleted
- [x] Review subjective zsh items — unused aliases, etc. (3.1) — reviewed and resolved; see commit e69e25b
- [x] Review env/ files for correctness (3.2) — all four env/ files reviewed; remote.zsh prompt and bat fallback fixed
- [x] Sheldon plugin keep/remove decisions (3.3) — all 6 plugins confirmed in use; history.zsh renamed to keybindings.zsh
- [x] Git account separation decision (4.1) — single GitHub account confirmed; includeIf removed
- [x] SSH config architecture decision (4.2) — template approach adopted; config/ssh/config committed; private hosts stay in ~/.ssh/config.local
- [x] bin/ script keep/remove decisions (5.2) — removed git-wtf, git-up, tmux_clipboard.sh; fixed bugs in brew-repair and curlperf
- [x] Cheatsheet tool-by-tool: still using? (6.3) — alfred/cvim/markdown/npm/vagrant/vim deleted; fzf/tmux updated; git/shell/kubernetes added
- [x] Copy retired cheatsheets to Obsidian before deletion (6.3) — alfred, markdown copied; cvim/npm/vagrant/vim discarded
- [x] Decide where `new_mac_setup.md` lives post-merge (6.2) — moved to Obsidian; deleted from repo
- [x] Decide where `StuffIUse.md` goes (6.4) — moved to Obsidian; deleted from repo
- [x] Gap items from `config/macos/Brewfile` reconciliation — placement decisions (7.3) — all entries placed; Brewfile deleted
- [x] Brewfile audit placement decisions (7.4) — all untracked packages reviewed and placed

---

## Appendix: Sequencing Notes

- **Phase 0 is prerequisite for everything.**
- **Phase 1 (removal) before Phases 3-5 (audits)** — no point auditing things we're about to delete.
- **2.1 (work.zsh)** before **3.2 (env/ review)** — resolution informs the review.
- **3.1 (zsh audit)** before **3.3 (sheldon)** — need to understand zsh usage before assessing plugin relevance.
- **Phase 5 config audits** can mostly run in parallel / any order.
- **Phase 6 (docs)** after all structural changes are done.
- **Phase 7 (verification)** is the final step before rollout.
- **Cheatsheets (6.3)** are collaborative and one-at-a-time — budget time for back-and-forth.
