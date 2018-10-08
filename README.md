shgit
-----

Unintrusive, lightweight git shell. Design/implementation considerations:

- No external dependencies other than git
- 256 Colors (c'mon, it's 2018)
- Configurable through git
- Modular, and extendable
- By default, invoke as little git operations as possible
  (for stupid enterprise environments/slow homes/low resources)
- Works with bash

Installation:
-------------
1. git clone git@github.com:roeme/shgit.git
2. cd shgit && ./install.sh install


Heavily inspired by Ryan Tomayko's git-sh.