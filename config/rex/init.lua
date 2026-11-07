-- Rex configuration (symlinked to ~/.config/rex/init.lua by ./install).
-- Docs: https://www.superlogical.com/rex/docs/customize/config
--
-- Hosts: the other Rex servers each machine can reach with `rex -S LABEL`.
-- Declaring them here gives every machine the same list without depending on a
-- shared "home" server. Each host's endpoint is the Rex server's own Tailscale
-- node (`rex whoami --json | jq -r .tailscale.https.url`), NOT the machine's
-- regular Tailscale name; Rex doesn't listen there.
--
-- Keep `id` stable: it is how Rex tracks a host across renames. Add hosts here
-- rather than with `rex hosts add`, which writes to the home server's stored
-- list instead of this file.

rex.host{
  label = "rum",
  id = "host:1aa04791-441f-49ce-a0fb-938bba348b93",
  endpoints = { "https://rum-rex.badger-micro.ts.net" },
}

rex.host{
  label = "studio",
  id = "host:57fc1512-4f21-4cf7-bb32-10f3f95c6ff0",
  endpoints = { "https://mac-studio-rex.badger-micro.ts.net" },
}
