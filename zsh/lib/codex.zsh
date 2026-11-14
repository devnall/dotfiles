# Local Codex profile; available only on machines where it has been set up.
if command -v codex >/dev/null 2>&1 && [[ -f "${CODEX_HOME:-$HOME/.codex}/cli.config.toml" ]]; then
  cx() {
    command codex -p cli "$@"
  }
fi
