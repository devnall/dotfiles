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
    aws-vault exec -- "$@"
  fi
}

function avl() {
  if [ $# -eq 0 ]; then
    aws-vault login -- cr-prod-admin
  else
    aws-vault login -- "$@"
  fi
}

function wfh() {
  ave cr-prod-admin bingo aws allow
  ave cr-stage-admin bingo aws allow
}

## docker stuff
[ -s "/Users/dnall/.dockercfg" ] && . "/Users/dnall/.dockercfg"

function dbuild() {
  docker build . -t "$1" --build-arg GITHUB_TOKEN="$GITHUB_TOKEN"  --build-arg SIDEKIQPRO_AUTH="$SIDEKIQPRO_AUTH"
}

## nvm stuff
export NVM_DIR="${HOME}/.nvm"

# this loads nvm
[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ] && . "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" 
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" 
#[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh" 

# this loads nvm completion
[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ] && . "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" 
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" 
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" 

## tfswitch stuff
# set default version
# v.0.12.18 as of Aug, 2021
if [[ -f "${HOMEBREW_PREFIX}/bin/tfswitch" || -f "/usr/local/bin/tfswitch" ]]; then
  export TF_VERSION=0.12.18
fi
