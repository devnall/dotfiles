# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/dnall/homebrew/opt/fzf/bin* ]]; then
  export PATH="$PATH:/Users/dnall/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/dnall/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if [ -f "/Users/dnall/homebrew/opt/fzf/shell/key-bindings.zsh" ]; then
  source "/Users/dnall/homebrew/opt/fzf/shell/key-bindings.zsh"
fi


#export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git --color=always . $HOME"
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type directory --exclude .git --color=always . $HOME"

# Aliases
# -------
alias preview="fzf --preview 'bat --color \"always\" {}'"
