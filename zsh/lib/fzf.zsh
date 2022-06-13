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

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type directory --hidden --exclude .git --color=always . $HOME"

bindkey "ç" fzf-cd-widget

# Aliases
# -------
alias preview="fzf --preview 'bat --color \"always\" {}'"
