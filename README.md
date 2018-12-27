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
- Intended to operate within one repo (one instance per repo)

Installation:
-------------
1. git clone git@github.com:roeme/shgit.git
2. cd shgit && ./install.sh install


Customization:
--------------
### General config
shgit is configured through git, and uses the section `[shgit]` if there's no
fitting standard section. The available options are documented at
[doc/options.md](doc/options.md).

### Commands
As commands/aliases are a - if not the - central functionality of shgit,
adjustment of these is documented at [doc/commands.md](doc/commands.md).

### Colors
Colors can be configured through git, by using the standard `[color]` section.
shgit uses the `shgit` prefix for configurable items. Have a look into the code
for a current list of things that can be colorized.


## Credits
Heavily inspired by Ryan Tomayko's git-sh.