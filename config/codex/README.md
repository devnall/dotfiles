# Codex CLI

Local profile: `cli.local.config.toml` (gitignored). Dotbot links this file to
`~/.codex/cli.config.toml` when it exists. Start with `codex -p cli`.

Personal instructions: `AGENTS.local.md` (also gitignored). Dotbot links it to
`~/.codex/AGENTS.md` when present. These instructions apply across Codex projects.
They preserve independent review, prefer worktrees for concurrent work, and
allow named Rex sessions to organize separate tasks.

After reloading the shell, `cx` runs `codex -p cli` and forwards all arguments.
The function is defined only when Codex and the local profile are available.
Claude-specific instruction fallback is deliberately disabled.

Keep `~/.codex` itself as a real directory. The desktop app manages its base
`config.toml`; credentials, sessions, caches, and runtime files stay local.
The CLI profile overlays the base config without replacing it.

The local profile permits workspace edits, asks for broader access, inherits
the existing model, and disables the desktop-only notification helper and
node_repl MCP bridge. No machine marker or shared defaults are selected yet.

See [the CLI cheatsheet](../../docs/codex.cheatsheet.md) for usage.
