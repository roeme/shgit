#shellcheck shell=bash
_gitcmpl_merge() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="--abort --continue --ff -e"
  if [[ ${cur} == -* ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  else
    COMPREPLY=( $(compgen -W "${_shgit_branches[*]##*/}" -- ${cur}) )
  fi
}