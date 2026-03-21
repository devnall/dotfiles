# Dotfiles — TODO

Deferred ideas and future improvements.

---

## Applications

- **Audit installed applications** — On each primary machine (personal desktop, personal laptop, work laptop), audit `/Applications` and `~/Applications`. Sort everything into the universal/work/personal Brewfile pattern. For apps only available via the Mac App Store, either automate with the `mas` CLI or document the manual install steps.

## Performance

- **Shell startup time audit** — Benchmark shell startup time on all primary machines (personal desktop, personal laptop, work laptop) using the RUNBOOK method. Target is under ~500ms warm. One laptop is currently 590–690ms after the mise migration. Profile with `zsh -x` or `zprof` to identify the slowest contributors and optimize if needed. **This should be one of the last TODOs worked from this list** — let other changes land first so the audit captures the final steady-state.

## Someday / Maybe

- **macOS defaults & OS customization** — Revisit `defaults write` settings for new machines: Dock config (auto-hide, icon size, remove default apps), keyboard repeat rate, trackpad settings, Finder preferences, screenshot location, etc. Consider reintroducing `config/macos/` with a `defaults.sh` script that bootstrap or install can call on macOS.
- **Codeberg setup** — If/when you want to try Codeberg for personal projects: add SSH key, host entry in SSH config, any git host-level config. Low effort.
- TODO: Consistent colors on all machines. Getting some weird issues with directory fg/bg in ls output on remote machines.
