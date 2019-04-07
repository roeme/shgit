#shellcheck shell=bash
_gitcmpl_checkout() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="-f"
  if [[ ${cur} == -* ]] ; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  else
    COMPREPLY=( $(compgen -o filenames -A file -W "${_shgit_branches[*]##*/}" -- ${cur}) )
  fi
}