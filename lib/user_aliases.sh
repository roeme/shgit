#!/bin/bash
#
# Loads user git aliases. As per their very nature, we don't do anything
# fancy with them (as opposed to other commands) and simply pass them on to
# git. However, since we let bash interpret these, we must make sure not to
# clash with shell keywords. If there are conflicts, warn the user and prefix
# the command.
#
function _shgit_load_user_aliases() {
  _shgit_init_msg "Loading your pre-defined git aliases"
  shell_keywords=( $(compgen -k) )

  eval "$(
      git config --get-regexp 'alias\..*' |
      sed 's/^alias\.//'                  |
      while read key command
      do
        if in_array shell_keywords $key; then
          [[ "${_shgit_suppress_keyword_alert:-,,}" = true ]] ||
            _shgit_warn_msg "Your git alias '$key' is a shell keyword. This usually results in much funkiness, and hence is available as 'git $key'."
          # By simply skipping here, we offload the alias interpretation to git.
          continue
        fi
        if expr -- "$command" : '!' >/dev/null
        then echo "alias $key='git $key'"
        else echo "alias $key=\"${alias_cmd_prefix} git $command\""
        fi
      done
    )"
}