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

# Jellyfish OTEL telemetry for Claude Code
# Org-specific endpoint and auth token are in ~/.secrets.local
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL="http/json"

# Unset $GITHUB_TOKEN per-invocation so `gh auth login` and friends use the
# keychain credential instead of erroring on the work-provided token.
if command -v gh > /dev/null; then
  alias gh="env GITHUB_TOKEN='' gh"
fi
