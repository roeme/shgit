#!/bin/bash
# either we are sourced or spawn new shell
[ "$0" = '-bash' ] || [ "$0" = */bash ] || [ "$0" = 'bash' ] ||
  {
    echo "Not sourced, exec new shell." >&2
    #/usr/bin/env bash -o --rcfile "$0" "$@" && exit
    /usr/bin/env bash --rcfile <(echo "source $0") "$@"
    exit
  }

echo "shgit starting up."

# read user bashrc
[[ -r ~/.bashrc ]] && {
  echo "Loading your ~/.bashrc" >&2
  pushd ~ > /dev/null
  . .bashrc
  popd > /dev/null
}
[[ -z "${PROMPT_COMMAND}" ]] || {
  echo "Clearing out your PROMPT_COMMAND for this shell." >&2
  unset PROMPT_COMMAND ;
}
echo "Disabling job control and enabling lastpipe option"
#unfortunately this doesn't (yet?) take effect when issued before
#first prompt has been displayed.
set +m
set +o monitor
shopt -s lastpipe
#PS1='`_git_headname``_git_upstream_state`!`_git_repo_state``_git_workdir``_git_dirty``_git_dirty_stash`> '
echo "Setting up git aliases... " >&2

# define aliases
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
  'grep           alias'
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
  'lfs            alias'
)
# load all aliases
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
echo "Setting up stock aliases done" >&2

echo "Loading your pre-defined git aliases" >&2
eval "$(
    git config --get-regexp 'alias\..*' |
    sed 's/^alias\.//'                  |
    while read key command
    do
      if expr -- "$command" : '!' >/dev/null
      then echo "alias $key='git $key'"
      else echo "gitalias $key=\"git $command\""
      fi
    done
  )"

#not yet.
#echo "Reading color escapes from git..."
ANSI_RESET="\001$(git config --get-color "" "reset")\002"

echo "Setting up prompt hook..." >&2
# initial load
current_worktree=$(git rev-parse --show-toplevel)
repo_name=$(basename "${current_worktree}")

# set info for prompt
function prompt_info {
  set +o monitor # currently needed here :/
  git rev-parse --show-toplevel --abbrev-ref HEAD | read -d '\n' current_worktree branch #|| { current_worktree='' ; repo_name='💤' ; }
}

function prompt_pwd {
  local pwdmaxlen=20
  local trunc_symbol="…"
  oldPWD="${PWD:${#current_worktree}}"
  if [ ${#oldPWD} -eq 0 ]; then
   newPWD=/
  elif [ ${#oldPWD} -gt $pwdmaxlen ]; then
    local pwdoffset=$(( ${#oldPWD} - $pwdmaxlen ))
    newPWD="${trunc_symbol}${oldPWD:$pwdoffset:$pwdmaxlen}"
  else
    newPWD=${oldPWD}
  fi
}
function shgit_prompt_cmd {
  prompt_info
  prompt_pwd
  PS1="${repo_name} ${branch} ${newPWD}> ${ANSI_RESET}"
}
PROMPT_COMMAND=shgit_prompt_cmd

echo "Shell setup done, ready. 🍻" >&2