# Dotfiles — TODO

Deferred ideas and future improvements.

---

## Performance

- **Shell startup time audit** — Benchmark shell startup time on all primary machines (personal desktop, personal laptop, work laptop) using the RUNBOOK method. Target is under ~500ms warm. One laptop is currently 590–690ms after the mise migration. Profile with `zsh -x` or `zprof` to identify the slowest contributors and optimize if needed. **This should be one of the last TODOs worked from this list** — let other changes land first so the audit captures the final steady-state.

## Someday / Maybe

- TODO: Run `brew doctor` on each machine, since if there's anything to deal with or cleanup
