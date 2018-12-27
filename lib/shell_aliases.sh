#!/bin/bash
#
# Setup up shell aliases. These are not interpreted by git, but by the shell
# (→ shgit).
#
function _shgit_setup_shell_aliases() {
  _shgit_init_msg "Setting up shell aliases..."
  shell_keywords=( $(compgen -k) )

  # Stock aliases. Can be overwritten
  declare -A _sh_cmd_aliases=(
    [pushall]='remote|xargs -L1 git push'
  )

  _shgit_init_msg "Loading your shgit shellcommands..."
  git config --get-regexp 'shgit.shellcommands\..*' |
      sed 's/^shgit.shellcommands\.//'              |
      while read key command; do
        if in_array shell_keywords $key; then
          [[ "${_shgit_suppress_keyword_alert:-,,}" = true ]] ||
            _shgit_warn_msg "Your shell alias '$key' is a shell keyword. This usually results in much funkiness, and hence is available as 'shgit $key'."
          _sh_cmd_aliases[$key]="shgit ${command}"
        else
          _sh_cmd_aliases[$key]="${command}"
        fi
      done
  _shgit_init_msg "Done loading your shellcommands, setting up aliases"
  for i in "${!_sh_cmd_aliases[@]}"; do
    [[ -n "${_sh_cmd_aliases[$i]:-}" ]] && alias $i="${_sh_cmd_aliases[$i]}"
  done
  _shgit_init_msg "Done setting up shell aliases."
}