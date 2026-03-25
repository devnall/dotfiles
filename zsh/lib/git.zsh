# My custom git aliases and configs

# Setup alias for 1password to interact with github via `gh` cli tool
# Guarded to TTY — non-interactive shells (e.g. IDE/editor subshells) should
# use gh's own auth token instead of triggering 1Password biometric prompts.
if [[ -t 1 ]] && [[ -f "${HOME}/.config/op/plugins.sh" ]]; then
  source "${HOME}/.config/op/plugins.sh"
fi

# Outputs the name of the current branch
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Back-compatibility wrapper
function current_branch() {
  git_current_branch
}

# Subset of aliases that should only be used if not using forgit plugin <github.com/wfxr/forgit>
function forgit_alias_check() {
  if ! command -v forgit::info > /dev/null; then
    alias ga='git add'
    alias glo='git log --oneline --decorate'
    alias grh='git reset'
    alias gcf='git config --list'
    alias gcb='git checkout -b'
    alias gco='git checkout'
    alias gss='git status -s'
    alias grb='git rebase'
  fi
}

forgit_alias_check

# Aliases

alias g='git'

alias gaa='git add --all'

alias gb='git branch'

alias gcmsg='git commit -m'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcam='git commit -a -m'
alias gcsm='git commit -s -m'

alias gcl='git clone --recurse-submodules'

alias gcm='git checkout $(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed "s@^refs/remotes/origin/@@" || echo "main")'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

alias ghh='git help'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'

alias gl='git pull'
alias glog='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glg="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glogg='git log --oneline --decorate --graph'
alias glogga='git log --oneline --decorate --graph --all'

alias gm='git merge'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'
alias gma='git merge --abort'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpv='git push -v'

alias gr='git remote -v'
alias gra='git remote add'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase develop'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grhh='git reset --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'

alias gsb='git status -sb'
alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'
alias gst='git status'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstall='git stash --all'
alias gsu='git submodule update'

alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash -v'
alias glum='git pull upstream master'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
