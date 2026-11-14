# Local Codex CLI setup

Start in the repository you want to work on:

```sh
cd ~/.dotfiles
codex -p cli
```

In a new shell, `cx` is shorthand for `codex -p cli`, forwarding all arguments.
For the current shell, run `source ~/.config/zsh/lib/codex.zsh` once.

The `cli` profile is linked from the gitignored
`~/.dotfiles/config/codex/cli.local.config.toml` to `~/.codex/cli.config.toml`.
It inherits the model
and other settings from `~/.codex/config.toml`, permits edits and commands
inside the workspace, and asks when broader access is needed. It disables
the desktop app's node_repl MCP bridge and notification helper for CLI sessions.
Plain `codex` uses your base configuration without this profile.

Useful commands inside a session:

- `/status`: inspect the active model, permissions, and context usage.
- `/model`: choose a model and reasoning effort.
- `/permissions`: inspect or change access for the session.
- `/plan`: plan a change before implementing it.
- `/diff`: inspect the current changes.
- `/review`: request a review.
- `/resume`: select a saved session.
- `/quit`: exit.

Useful commands in the shell:

```sh
codex -p cli resume --last        # Continue the most recent session
codex -p cli resume               # Pick a previous session
codex -p cli --worktree           # Start in a separate Git worktree
codex -p cli --search             # Use live web search
codex -p cli -s read-only         # Explore with read-only command access
codex doctor --summary           # Check base installation and connectivity
brew upgrade --cask codex         # Update this Homebrew installation
```

`doctor` does not accept `--profile`. It may report missing desktop-only
node_repl environment variables in a terminal; the `cli` profile disables that
server for actual sessions. Use `/status` inside a session to inspect its config.

Try a first prompt:

> Read README.md and docs/ARCHITECTURE.md. Summarize how this repo
> works and suggest one small improvement. Don't change any files yet.

Personal instructions are linked from the gitignored
`config/codex/AGENTS.local.md` to `~/.codex/AGENTS.md`. They apply across projects;
repo-specific instructions belong in a repository's `AGENTS.md`.

For an independent review, start a new Codex session with the original ticket,
acceptance criteria, and the code or diff. Ask it to assess those before reading
another agent's rationale. Claude-specific instructions, memories, and transcripts
are not read automatically. The CLI profile has no `CLAUDE.md` fallback.

Use `cx --worktree` when separate work needs its own checkout. A Rex session
organizes terminals but does not isolate files. For an explicitly named worktree
and Rex session, run from the repository root (choose names for your task):

```sh
git worktree add ../project-issue-123 -b issue/123
rex new issue-123 --cwd "$PWD/../project-issue-123" -- codex -p cli
```

The Rex command launches Codex directly, so it does not depend on the `cx` shell
function. Use Rex only when available and useful; keep existing sessions intact.

Keep auth.json, history, sessions, and machine-specific app settings local.
Dotbot links only the CLI profile when its local source exists. The profile's
values are local to this machine until we choose defaults to share.

Official configuration docs:
https://learn.chatgpt.com/docs/config-file/config-basic
https://learn.chatgpt.com/docs/config-file/config-advanced#profiles
