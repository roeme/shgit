#!/usr/bin/env bash
# be quiet if the user requested so.
_shgit_quiet_init="$(git config shgit.quiet-init)"
_shgit_location="$(git config shgit.location)"

[[ -n "${_shgit_location:-}" ]] || {
  echo "shgit.location has not been configured! Please configure or use install.sh"
  exit 1
}

# either we are sourced or spawn new shell
[ "$0" = '-bash' ] || [[ "$0" = */bash ]] || [ "$0" = 'bash' ] ||
  {
    [[ -n "${_shgit_quiet_init:-}" ]] ||
      echo "Not sourced, exec new shell." 1>&2
    /usr/bin/env bash --rcfile <(echo "source $0") "$@"
    exit
  }

[[ -n "${_shgit_quiet_init:-}" ]] ||
  echo "shgit starting up." 1>&2
# Load functions'n'stuff from external files
_shgit_libfiles=(${_shgit_location}/lib/*)
_cel=$(tput el)
i=0; c=${#_shgit_libfiles[@]} ; echo -en '\n'
for libfile in "${_shgit_libfiles[@]}" ; do
  [[ -n "${_shgit_quiet_init:-}" ]] || {
    echo -en "${_cel}\r"
    i=$((i+1))
    printf "[ %${#c}d/${c} ] ${libfile##*/}" $i
  }
  source $libfile
done
unset -v i c ; echo -en "\r${_cel}"

_shgit_read_userbashrc

_shgit_init_msg "Disabling job control and enabling lastpipe option"
#unfortunately this doesn't (yet?) take effect when issued before
#first prompt has been displayed. Need to investigate further.
set +m
set +o monitor
shopt -s lastpipe

_shgit_load_settings
_shgit_completions_setup

_shgit_init_msg "Setting up git aliases... "

# define aliases. TODO: factor this outta here/make it configurable
_git_cmd_cfg=(
  'add            alias'
  'bisect         alias'
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
  'reflog         alias'
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
# load all aliases
for cfg in "${_git_cmd_cfg[@]}" ; do
  read cmd opts <<< $cfg
  for opt in $opts ; do
    case $opt in
      alias)
        alias $cmd="${alias_cmd_prefix}git $cmd" ;;
      stdcmpl)
        complete -o nospace -F _gitcmpl_${cmd//-/_} $cmd
        source ${_shgit_location}/completions/${cmd//-/_}.sh
      ;;
    esac
  done
done
_shgit_init_msg "Setting up stock aliases done"
_shgit_setup_shell_aliases
_shgit_setup_user_aliases
_shgit_setup_palette

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
  local pwdmaxlen="${_shgit_pwd_max_len}"
  local trunc_symbol="${_shgit_trunc_symbol}"
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

function shgit_stealthy_prompt_cmd {
  PS1="${_sghit_ps1_prefix}${PS1}"
}

case $_sghit_prompt_mode in
  override)
    [[ -z "${PROMPT_COMMAND}" ]] || {
      _shgit_init_msg "Clearing out your PROMPT_COMMAND for this shell."
      unset PROMPT_COMMAND ;
    }
    PROMPT_COMMAND=shgit_prompt_cmd
  ;;
  stealthy)
    _sghit_ps1_prefix="$(git config shgit.ps1-prefix 2> /dev/null || echo "🐚 ")"
    if [[ -n "${PROMPT_COMMAND}" ]]; then
      _shgit_init_msg "Adjusting your PROMPT_COMMAND for this shell."
      PROMPT_COMMAND=$"${PROMPT_COMMAND};shgit_stealthy_prompt_cmd"
    else
      shgit_stealthy_prompt_cmd
    fi
  ;;
  no-touchy)
    # noop
  ;;
  custom)
    _sghit_custom_prompt_command="$(git config shgit.custom-prompt-command)"
    [[ -n "${_sghit_custom_prompt_command:-}" ]] || {
      _shgit_die "Custom prompt command requested but none set"
      exit 1
    }
  ;;
  *)
    _shgit_die "Unknown prompt mode: $_sghit_prompt_mode"
    exit 1
  ;;
esac

_shgit_hookcd_cond
_shgit_init_msg "Shell setup done, ready. 🍻"
