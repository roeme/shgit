#!/bin/bash
function _shgit_setup_git_aliases() {
  _shgit_init_msg "Setting up git aliases... "
  shopt -s lastpipe
  # Stock aliases. Can be overwritten.
  declare -A _git_cmd_cfg=(
    [add]='alias'
    [bisect]='alias'
    [blame]='alias'
    [branch]='alias'
    [checkout]='alias stdcmpl'
    [cherry]='alias'
    [cherry-pick]='alias'
    [clean]='alias'
    [clone]='alias'
    [commit]='alias'
    [config]='alias'
    [diff]='alias'
    [fetch]='alias'
    [fsck]='alias'
    [gc]='alias'
    [grep]='alias'
    [init]='alias'
    [log]='alias'
    [ls-remote]='alias'
    [ls-tree]='alias'
    [merge]='alias stdcmpl'
    [merge-base]='alias'
    [mergetool]='alias'
    [mv]='alias'
    [pull]='alias'
    [push]='alias stdcmpl'
    [rebase]='alias'
    [reflog]='alias'
    [remote]='alias stdcmpl'
    [reset]='alias'
    [rev-list]='alias'
    [rev-parse]='alias'
    [revert]='alias'
    [rm]='alias'
    [shortlog]='alias'
    [show]='alias'
    [stash]='alias'
    [status]='alias'
    [tag]='alias'
    [lfs]='alias'
  )
  # declare verbose exec function if enabled
  if [[ "${_shgit_verbose_exec_setting:false}" = true ]]; then
    function _shgit_verbose_alias() {
      echo -n "> " 1>&2
      printf "%q " "$@" 1>&2
      echo -ne "\n" 1>&2
      "$@"
    }
    alias_cmd_prefix='_shgit_verbose_alias '
  else
    alias_cmd_prefix=''
  fi

  _shgit_init_msg "Loading your shgit git commands..."
  git config --get-regexp 'shgit.commands\..*' |
      sed 's/^shgit.commands\.//'              |
      while read -r key cfg; do
         _git_cmd_cfg[$key]="${cfg}"
      done
  _shgit_init_msg "Done loading your shgit git commands, setting up aliases"

  # load all aliases
  for cmd in "${!_git_cmd_cfg[@]}"; do
    for opt in ${_git_cmd_cfg[$cmd]}; do
      case "$opt" in
        alias)
          # shellcheck disable=SC2139,SC2086
          alias $cmd="${alias_cmd_prefix}git $cmd" ;;
        stdcmpl)
          complete -o nospace -F _gitcmpl_${cmd//-/_} $cmd
          source ${_shgit_location}/completions/${cmd//-/_}.sh
        ;;
      esac
    done
  done

  _shgit_init_msg "Setting up git commands done"
}