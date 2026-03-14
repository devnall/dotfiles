# Setup fzf
# ---------

if [[ -d /usr/local/opt/fzf/ ]]; then
  FZF_PATH="/usr/local/opt/fzf/"
elif [[ -d /opt/homebrew/opt/fzf/ ]]; then
  FZF_PATH="/opt/homebrew/opt/fzf/"
fi

if [[ ! "$PATH" == *$FZF_PATH/bin* ]]; then
  export PATH="$PATH:$FZF_PATH/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_PATH/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if [ -f "$FZF_PATH/shell/key-bindings.zsh" ]; then
  source "$FZF_PATH/shell/key-bindings.zsh"
fi

# Shell integration
# -----------------
source <(fzf --zsh)

# Command keybinds
# ----------------
export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :800 {}'"
export FZF_ALT_C_COMMAND="fd --type directory --hidden --exclude .git --color=always . $HOME"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

bindkey "ç" fzf-cd-widget

# Function to do some advanced customization of fzf options based on context
# The first argument is the name of the command
# Make sure to pass the rest of the arugments to fzf
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                    "$@" ;;
    *)            fzf --preview "--preview 'bat -n --color=always --line-range :800 {}'" "$@" ;;
  esac
}

# Aliases
# -------
alias preview="fzf --preview 'bat --color \"always\" {}'"
