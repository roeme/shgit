#shellcheck shell=bash
_gitcmpl_push() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  COMPREPLY=( $(compgen -W "${_shgit_remotes[*]}" -- ${cur}) )
}