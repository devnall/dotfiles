Perform a wrap-up review of the current work before moving on. Check each of the following and report findings concisely:

1. **Uncommitted changes** — Run `git status` and `git diff`. Flag anything unstaged or uncommitted.
2. **Stale TODOs** — Read the project's TODO file (if one exists) and check for items that are now outdated, completed, or contradicted by work on the current branch. Also check for new TODOs that should be added based on decisions made during the session.
3. **Doc drift** — If docs like ARCHITECTURE.md, RUNBOOK.md, or README.md exist, scan them for references to things changed on the current branch (renamed files, removed features, new tools, changed conventions). Flag anything that looks stale.
4. **Memory worth saving** — Review the conversation for user preferences, corrections, project context, or reference information that would be valuable in future sessions but isn't already saved. Propose specific memories (don't save without confirmation).
5. **Context hygiene** — If the conversation context is heavy, suggest `/compact` or `/clear`.

Format the output as a checklist with findings under each item. If everything is clean for a category, say so in one line. Be direct — skip categories with nothing to report.
