# Work-specific shell configuration
# Sourced automatically when ~/.work marker file exists

# aws-vault
export AWS_VAULT_KEYCHAIN_NAME=login

function ave() {
  if [ $# -eq 0 ]; then
    aws-vault exec --duration=12h -- cr-prod
  else
    aws-vault exec --duration=12h -- "$@"
  fi
}

function avl() {
  if [ $# -eq 0 ]; then
    aws-vault login -- cr-prod-admin
  else
    aws-vault login -- "$@"
  fi
}
