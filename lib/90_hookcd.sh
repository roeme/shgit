#!/bin/bash
function _shgit_hookcd_cond() {
  if [[ "$(git config "shgit.hook-cd")" = "true" ]]; then
  _shgit_init_msg "Hooking cd..."
  function cd {
    if [[ "${#:0}" -gt 0 ]]; then
      builtin cd "$@" || return
    else
      builtin cd "$current_worktree" || return
    fi
  }
  fi
}