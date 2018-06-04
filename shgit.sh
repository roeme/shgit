#!/bin/bash

# either we are sourced or spawn new shell
[ "$0" = 'bash' ] ||
  exec /usr/bin/env bash --rcfile "$0" "$@"

# read user bashrc
[[ -r ~/.bashrc ]] && {
  pushd ~ > /dev/null
  . .bashrc
  popd > /dev/null
}

[[ -z "${PROMPT_COMMAND}" ]] || unset PROMPT_COMMAND

#PS1='`_git_headname``_git_upstream_state`!`_git_repo_state``_git_workdir``_git_dirty``_git_dirty_stash`> '

export PS1='shgit> '

_git_cmd_cfg=(
  'add            alias'
  'blame          alias'
  'branch         alias'
  'checkout       alias'
  'cherry         alias'
  'cherry-pick    alias'
  'clean          alias'
  'clone          alias'
  'commit         alias'
  'config         alias'
  'diff           alias'
  'fetch          alias'
  'fsck           alias'
  'gc             alias'
  'init           alias'
  'log            alias'
  'ls-remote      alias'
  'ls-tree        alias'
  'merge          alias'
  'merge-base     alias'
  'mergetool      alias'
  'mv             alias'
  'pull           alias'
  'push           alias'
  'rebase         alias'
  'remote         alias'
  'reset          alias'
  'rev-list       alias'
  'rev-parse      alias'
  'revert         alias'
  'rm             alias'
  'shortlog       alias'
  'show           alias'
  'stash          alias'
  'status         alias'
  'tag            alias'
)

for cfg in "${_git_cmd_cfg[@]}" ; do
  read cmd opts <<< $cfg
  for opt in $opts ; do
    case $opt in
      alias)   alias $cmd="git $cmd" ;;
      #stdcmpl) complete -o default -o nospace -F _git_${cmd//-/_} $cmd ;;
      #logcmpl) complete -o default -o nospace -F _git_log         $cmd ;;
    esac
  done
done
