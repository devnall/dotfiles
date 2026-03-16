# Dotfiles — TODO (Future Phase)

Items that came up during cleanup project planning but are out of scope for the current effort. Add these to your existing dotfiles TODO.md or use this as a standalone tracker.

---

## Rollout & Multi-Machine

- **Multi-machine rollout and testing** — Clone the updated repo on all other machines, run `./install`, verify everything works. Pull in any local customizations (`~/.env.local` contents, useful drift) back into the repo.
- **Brewfile cross-machine reconciliation** — After rollout, run `brew leaves` / `brew list --cask` / `brew bundle dump` on each machine. Reconcile differences across machines and ensure every package is in the right Brewfile (universal / work / personal).
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

TODO: Fix up minimal vim. Needs to at least have a decent colorscheme and not throw errors at start.
TODO: On all machine types other than "Remote" (that is, on Work, Personal, and Remote-Full machines), if nvim is installed, alias something to it. I have muscle memory to type "vim" but if it's bad form to alias nvim to vim, I should find a new alias -- maybe "e" for "edit"?
TODO: Try background-opacity and blur in Ghostty config (e.g. background-opacity = 0.90, window-blur was used in old Alacritty config). See if it works well with the current themes.
TODO: Save the dark_nord Ghostty theme palette to Obsidian (colors are in config/ghostty/themes/dark_nord), then delete the file from the repo — it's not referenced in the Ghostty config.
TODO: Try to remove external dependecy in `bat` for the `rose-pine-dawn` theme. Try to create a local copy of the theme. If successful, remove the step from `install.config.yaml` to curl the theme (and any associated documentation that would no longer be relevant).
TODO: Implement automatic dark/light theme switching on macOS appearance change. Affects tmux and btop (and potentially others). Best approach: `brew install dark-notify` (keith/formulae) + a LaunchAgent that fires callbacks on appearance change — e.g. `tmux source ~/.config/tmux/tmux.conf` and a btop config patcher. Design the solution holistically across all affected tools before implementing. Alternately, consider a native polling approach to reduce external dependencies.
TODO: See if I can get custom btop NordicPine theme
TODO: Document my theme palletes independently of shell configs, so that I can use them other places.
TODO: Figure out 1Password "op" cli tool and the permissions popups for it I keep getting.
TODO: Make 1Password IdentityAgent path in config/ssh/config portable across
OSes. macOS uses ~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock;
Linux uses ~/.1password/agent.sock. Consider Match/Host-based conditionals or
a local override in ~/.ssh/config.local.
TODO: Can I keep ssh.local files in 1Password and manage w/ 1Pass cli for work/personal
TODO: Remove profile names from env/work.zsh, replace with vars, keep real
values in secret file. Also keep secret file in 1Password and use 1Password
CLI tool to make it portable across work/personal machines. Document all of
that.
TODO: Can I have custom responses for tldr/tealdeer with my own
alias/cheatsheet entries?
TODO: Migrate language runtime management to mise — this is now a first-class requirement.
Scope includes: python, ruby, rust (currently installed ad-hoc or via Homebrew), tfenv/tenv
(terraform versions), nvm (node), rbenv (ruby). Goal: mise as single source of truth for all
runtimes; remove redundant version managers and Homebrew-managed language packages. Also
update Brewfile.universal to remove any remaining Homebrew-managed runtimes once migrated.

