# Dotfiles

## Public Repository

This is a **public** GitHub repository. Before every commit, verify that no sensitive information is included:

- No hostnames, IPs, or internal server names
- No API keys, tokens, or credentials
- No private SSH config (usernames, internal domains, host aliases)
- No personal data that shouldn't be public

When in doubt, flag it to the user before staging. This applies to all files — configs often contain sensitive values by nature.

Before committing or pushing, read the sharing rules in `README.md` and run
`make check-private` after staging the intended files. A clean scan does not
replace review of the staged diff. Never bypass a failed privacy check or rewrite
shared history without explicit authorization.

When changing global agent instructions for sharing, update the tracked
`CLAUDE.md.template` and `AGENTS.md.template`; generated personalized files stay local.
