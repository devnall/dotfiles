# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if [ -f "/usr/local/opt/fzf/shell/key-bindings.zsh" ]; then
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
fi

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type directory --hidden --exclude .git --color=always . $HOME"


# Aliases
# -------
alias preview="fzf --preview 'bat --color \"always\" {}'"
