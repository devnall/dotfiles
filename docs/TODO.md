# Dotfiles — TODO

Deferred ideas and future improvements.

---

## Applications

- **Evaluate mackup for app settings backup** — Decide whether to use mackup to backup and sync Mac app settings as part of this repo, find a better alternative, or uninstall it. Currently quarantined in Brewfile.universal but still installed.

## Performance

- **Shell startup time audit** — Benchmark shell startup time on all primary machines (personal desktop, personal laptop, work laptop) using the RUNBOOK method. Target is under ~500ms warm. One laptop is currently 590–690ms after the mise migration. Profile with `zsh -x` or `zprof` to identify the slowest contributors and optimize if needed. **This should be one of the last TODOs worked from this list** — let other changes land first so the audit captures the final steady-state.

## Someday / Maybe

- **Codeberg setup** — If/when you want to try Codeberg for personal projects: add SSH key, host entry in SSH config, any git host-level config. Low effort.
- TODO: Consistent colors on all machines. Getting some weird issues with directory fg/bg in ls output on remote machines.
- TODO: Run `brew doctor` on each machine, since if there's anything to deal with or cleanup
