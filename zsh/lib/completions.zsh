# AWS cli completions
if [ -f /Users/dnall/homebrew/bin/aws_zsh_completer.sh ]
then
  source /Users/dnall/homebrew/bin/aws_zsh_completer.sh
fi

# kubectl completions
if [ -f /Users/dnall/homebrew/bin/kubectl ]
then
  source <(kubectl completion zsh)
fi
