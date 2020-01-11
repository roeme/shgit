#!/bin/bash
# completion stuff
function _shgit_completions_setup() {
  _shgit_init_msg "Clearing out existing completions..."
  complete -r
  _shgit_init_msg "Resetting default completion options."
  complete -Ea # complete only aliases when encountering empty line
  if [[ "${BASH_VERSINFO[0]}" -eq 5 ]]; then
    # nice, bash 5. further limit completion to aliases only
    complete -aI
  fi
}