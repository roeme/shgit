#!/bin/bash
# be quiet if the user requested so.
_shgit_quiet_init="$(git config shgit.quiet-init)"
_shgit_suppress_keyword_alert="$(git config shgit.suppress-keyword-message)"

function _shgit_init_msg() {
  [[ "${_shgit_quiet_init:-,,}" = true ]] || _shgit_msg $1
}

function _shgit_msg() {
  echo "$1" >&2
}

# either we are sourced or spawn new shell
[ "$0" = '-bash' ] || [ "$0" = */bash ] || [ "$0" = 'bash' ] ||
  {
    _shgit_init_msg "Not sourced, exec new shell."
    /usr/bin/env bash --rcfile <(echo "source $0") "$@"
    exit
  }

_shgit_init_msg "shgit starting up."
function in_array() {
  local -n arr=$1
  for item in "${arr[@]}"; do
    [[ "${item}" = "${2}" ]] && return 0
  done
  return 1
}

# read user bashrc
[[ -r ~/.bashrc ]] && {
  _shgit_init_msg "Loading your ~/.bashrc"
  pushd ~ > /dev/null
  . .bashrc
  popd > /dev/null
}
[[ -z "${PROMPT_COMMAND}" ]] || {
  _shgit_init_msg "Clearing out your PROMPT_COMMAND for this shell."
  unset PROMPT_COMMAND ;
}
_shgit_init_msg "Disabling job control and enabling lastpipe option"
#unfortunately this doesn't (yet?) take effect when issued before
#first prompt has been displayed. Need to investigate further.
set +m
set +o monitor
shopt -s lastpipe

_shgit_init_msg "Clearing out existing completions..."
complete -r

_shgit_init_msg "Setting up git aliases... "

# define aliases. TODO: factor this outta here/make it configurable
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
  'merge          alias stdcmpl'
  'merge-base     alias'
  'mergetool      alias'
  'mv             alias'
  'pull           alias'
  'push           alias'
  'rebase         alias'
  'remote         alias stdcmpl'
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
      stdcmpl)
        complete -o default -o nospace -F _gitcmpl_${cmd//-/_} $cmd
        source ~/.libexec/shgit_completions/${cmd//-/_}.sh
      ;;
    esac
  done
done
_shgit_init_msg "Setting up stock aliases done"
_shgit_init_msg "Setting up shell aliases..."
_sh_cmd_aliases=(
  'pushall    remote|xargs -L1 git push'
  )
for cmd_alias_entry in "${_sh_cmd_aliases[@]}"; do
  read cmd cmd_alias <<< $cmd_alias_entry
  alias $cmd="$cmd_alias"
done
_shgit_init_msg "Done setting up shell aliases."
_shgit_init_msg "Loading your pre-defined git aliases"
shell_keywords=( $(compgen -k) )
eval "$(
    git config --get-regexp 'alias\..*' |
    sed 's/^alias\.//'                  |
    while read key command
    do
      if in_array shell_keywords $key; then
        [[ "${_shgit_suppress_keyword_alert:-,,}" = true ]] ||
          _shgit_msg "Warning: Your git alias '$key' is a shell keyword. This usually results in much funkiness, and hence is available as 'git $key'."
        # By simply skipping here, we offload the alias interpretation to git.
        continue
      fi
      if expr -- "$command" : '!' >/dev/null
      then echo "alias $key='git $key'"
      else echo "alias $key=\"git $command\""
      fi
    done
  )"

_shgit_init_msg "Setting up color palette..."
_get_colors_default=(
  'reponame        208 234'
  'currentbranch   034'
  'pwd             250'
  'prompt          254 0'
  )
ANSI_RESET="\001$(git config --get-color "" "reset")\002"
declare -A shg_colors
_shgit_init_msg "Reading color escapes from git..."
for defaultcol_entry in "${_get_colors_default[@]}"; do
  read colsetting default_color <<< $defaultcol_entry
  shg_colors[${colsetting}]="\001$(git config --get-color color.shgit.${colsetting} "${default_color}")\002"
done

_shgit_init_msg "Setting up prompt hook..."
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
  PS1="${shg_colors[reponame]}${repo_name} ${shg_colors[currentbranch]}${branch} ${shg_colors[pwd]}${newPWD} ${shg_colors[prompt]}\$${ANSI_RESET} "
}
PROMPT_COMMAND=shgit_prompt_cmd

_shgit_init_msg "Shell setup done, ready. 🍻"
