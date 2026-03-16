# Git Cheatsheet

Aliases from `zsh/lib/git.zsh`. Forgit interactive versions replace `ga`, `glo`, `grh`, `gcf`, `gcb`, `gco`, `gss`, `grb` when the forgit plugin is active.

---

## Basics

| Alias | Command |
|-------|---------|
| `g` | `git` |
| `gst` | `git status` |
| `gsb` | `git status -sb` (short + branch) |
| `gsh` | `git show` |
| `gsps` | `git show --pretty=short --show-signature` |
| `ghh` | `git help` |
| `grt` | `cd` to repo root |

## Staging

| Alias | Command |
|-------|---------|
| `ga` | `git add` (forgit: interactive) |
| `gaa` | `git add --all` |
| `gignore` | `git update-index --assume-unchanged <file>` |
| `gignored` | List all assume-unchanged files |

## Committing

| Alias | Command |
|-------|---------|
| `gc` | `git commit -v` |
| `gc!` | `git commit -v --amend` |
| `gca` | `git commit -v -a` |
| `gca!` | `git commit -v -a --amend` |
| `gcam` | `git commit -a -m` |
| `gcmsg` | `git commit -m` |
| `gcsm` | `git commit -s -m` (signed-off-by) |

## Branches

| Alias | Command |
|-------|---------|
| `gb` | `git branch` |
| `gcb` | `git checkout -b` (forgit: interactive) |
| `gcm` | Checkout default branch (auto-detects main/master) |
| `gco` | `git checkout` (forgit: interactive) |
| `gcl` | `git clone --recurse-submodules` |

## Fetch / Pull / Push

| Alias | Command |
|-------|---------|
| `gf` | `git fetch` |
| `gfa` | `git fetch --all --prune` |
| `gfo` | `git fetch origin` |
| `gl` | `git pull` |
| `gup` | `git pull --rebase` |
| `gupv` | `git pull --rebase -v` |
| `gupa` | `git pull --rebase --autostash` |
| `gupav` | `git pull --rebase --autostash -v` |
| `glum` | `git pull upstream master` |
| `gp` | `git push` |
| `gpd` | `git push --dry-run` |
| `gpv` | `git push -v` |
| `gpsup` | `git push --set-upstream origin <current-branch>` |
| `ggsup` | `git branch --set-upstream-to=origin/<current-branch>` |

## Rebase

| Alias | Command |
|-------|---------|
| `grb` | `git rebase` (forgit: interactive) |
| `grbi` | `git rebase -i` |
| `grbd` | `git rebase develop` |
| `grbm` | `git rebase master` |
| `grbc` | `git rebase --continue` |
| `grba` | `git rebase --abort` |
| `grbs` | `git rebase --skip` |

## Merge

| Alias | Command |
|-------|---------|
| `gm` | `git merge` |
| `gmom` | `git merge origin/master` |
| `gmum` | `git merge upstream/master` |
| `gmt` | `git mergetool --no-prompt` |
| `gmtvim` | `git mergetool --no-prompt --tool=vimdiff` |
| `gma` | `git merge --abort` |

## Reset

| Alias | Command |
|-------|---------|
| `grh` | `git reset` (forgit: interactive hunk reset) |
| `grhh` | `git reset --hard` |
| `gru` | `git reset --` |
| `gunwip` | Undo last commit if it was a WIP commit |

## Stash

| Alias | Command |
|-------|---------|
| `gsta` | `git stash save` |
| `gstaa` | `git stash apply` |
| `gstp` | `git stash pop` |
| `gstl` | `git stash list` |
| `gsts` | `git stash show --text` |
| `gstd` | `git stash drop` |
| `gstc` | `git stash clear` |
| `gstall` | `git stash --all` |

## Remotes

| Alias | Command |
|-------|---------|
| `gr` | `git remote -v` |
| `grv` | `git remote -v` |
| `gra` | `git remote add` |
| `grmv` | `git remote rename` |
| `grrm` | `git remote remove` |
| `grset` | `git remote set-url` |
| `grup` | `git remote update` |
| `grm` | `git rm` |
| `grmc` | `git rm --cached` |

## Log / History

| Alias | Command |
|-------|---------|
| `glo` | `git log --oneline --decorate` (forgit: interactive) |
| `glog` | `git log --stat` |
| `glgp` | `git log --stat -p` |
| `glgg` | `git log --graph` |
| `glgm` | `git log --graph --max-count=10` |
| `glgga` | `git log --graph --decorate --all` |
| `glg` | Pretty graph log with author + relative time |
| `glogg` | `git log --oneline --decorate --graph` |
| `glogga` | `git log --oneline --decorate --graph --all` |
| `gwch` | `git whatchanged -p --abbrev-commit --pretty=medium` |

## Submodules

| Alias | Command |
|-------|---------|
| `gsu` | `git submodule update` |

## Config

| Alias | Command |
|-------|---------|
| `gcf` | `git config --list` (forgit: interactive) |
| `gss` | `git status -s` (forgit: interactive diff) |

---

## Forgit Interactive Commands

When the forgit plugin is active, these replace simple aliases with interactive fzf-powered equivalents:

| Command | Action |
|---------|--------|
| `ga` | Interactive `git add` — stage hunks/files with fzf |
| `glo` | Interactive log browser |
| `grh` | Interactive `git reset` — unstage hunks |
| `gcf` | Interactive `git config --list` |
| `gcb` | Interactive branch checkout |
| `gco` | Interactive file checkout |
| `gss` | Interactive `git status` with diff preview |
| `grb` | Interactive rebase |

---

## Lazygit

| Alias | Command |
|-------|---------|
| `lg` | Open lazygit TUI |
