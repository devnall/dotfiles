## Local customizations for CallRail stuff

## ruby/rails stuff
eval "$(rbenv init -)"

## aws-vault stuff

export AWS_VAULT_KEYCHAIN_NAME=login

function _ps1_value() {
  if [ -z "$AWS_VAULT" ]; then
    echo "%n@%m  %1d"
  else
    echo "$AWS_VAULT@aws  %1d"
  fi
}

export PS1="[$(_ps1_value)]\$ "

function ave() {
  if [ $# -eq 0 ]; then
    aws-vault exec -- cr-prod-admin
  else
    aws-vault exec -- $@
  fi
}

function avl() {
  if [ $# -eq 0 ]; then
    aws-vault login -- cr-prod-admin
  else
    aws-vault login -- $@
  fi
}

## docker stuff
[ -s "/Users/drew/.docercfg" ] && . "/Users/drew/.dockercfg"

function dbuild() {
  docker build . -t $1 --build-arg GITHUB_TOKEN=$GITHUB_TOKEN  --build-arg SIDEKIQPRO_AUTH=$SIDEKIQPRO_AUTH
}

## nvm stuff
export NVM_DIR="$HOME/.nvm"

# this loads nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" 

# this loads nvm completion
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" 

## tfswitch stuff
# set default version
# v.0.12.18 as of Aug, 2021
if [[ -f "$HOME/homebrew/bin/tfswitch" || -f "/usr/local/bun/tfswitch" ]]; then
  export TF_VERSION=0.12.18
fi
