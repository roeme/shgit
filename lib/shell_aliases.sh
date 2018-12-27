#!/bin/bash
function _shgit_setup_shell_aliases() {
  _shgit_init_msg "Setting up shell aliases..."
  _sh_cmd_aliases=(
    'pushall    remote|xargs -L1 git push'
  )
  for cmd_alias_entry in "${_sh_cmd_aliases[@]}"; do
    read cmd cmd_alias <<< $cmd_alias_entry
    alias $cmd="$cmd_alias"
  done
  _shgit_init_msg "Done setting up shell aliases."
}