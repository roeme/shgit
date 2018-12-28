shgit command configuration
===========================

Basics
------

shgit knows two different type of commands:
1.  git commands
2.  shell commands

The former are essentially passed through unchanged to git, so `commit` becomes
`git commit`. The latter ones are interpreted by shgit itself.¹

Any commands that are not defined are interpreted by the shell regularly as-is.
For example: `rm` is by default a git command and will be executed as
`git rm` - but undefining the command will - on most systems - cause `/bin/rm`
to be executed instead.

shgit comes with a certain set of standard commands defined, which you can
extend, change and limit to your will; simply configure
`shgit.commands.<COMMANDNAME>` (for git commands) and
`shgit.shellcommands.<COMMANDNAME>` (for shell commands) to your liking.
To undefine a command, simply empty its value (for example: `git config --global shgit.commands.rm ''`).

¹(Both are augmented shell aliases - but to prevent confusion with regular
git aliases, they are designated as above).


## 1. git commands
As mentioned above, available git commands are configured in the
configuration subsection `[shgit "commands"]`. Most of git commands are already pre-defined internally.

To make a command available, simply set `shgit.commands.<COMMANDNAME>` to
`alias`. To enable command completion, add `stdcmpl` separated by a space.

This section (and functionality) will be extended in the future.

## 2. shell commands
Shell commands are configured in the git configuration subsection `[shgit "shellcommands"]`. The following stock commands pre-defined:

* `pushall`: defined as `remote|xargs -L1 git push`

  Will push to all available remotes.