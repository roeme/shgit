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


Configuration:
--------------
shgit is configured through git, and uses the section `[shgit]` if there's no
fitting standard section. The following options are available in `[shgit]`:

* `quiet_init` (True/False):
  Don't print initialization messages.
* `suppress_keyword_alert` (True/False):
  If your aliases include a shell keyword, shgit will warn upon this and won't
  make the alias available at top-level. This setting will suppress the message.

## Colors
Colors can be configured through git, by using the standard `[color]` section.
shgit uses the `shgit` prefix for configurable items. Have a look into the code
for a current list of things that can be colorized.

Heavily inspired by Ryan Tomayko's git-sh.