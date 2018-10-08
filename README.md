shgit
-----

Unintrusive, lightweight git shell. Design/implementation considerations:

- No external dependencies other than git and bash
- 256 Colors (c'mon, it's 2018)
- Configurable through git
- Modular, and extendable
- By default, invoke as little git operations as possible
  (for stupid enterprise environments/slow homes/low resources)
- Works with vanilla bash
- Doesn't clobber your personal aliases/setups (or at least tries to)

Installation:
-------------
1. git clone git@github.com:roeme/shgit.git
2. cd shgit && ./install.sh install


Heavily inspired by Ryan Tomayko's git-sh.