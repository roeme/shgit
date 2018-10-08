_gitcmpl_remote() {
  local cur prev subcmds
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  subcmds="add rename remove set-head show"
  if [[ $prev == remote ]]; then
    COMPREPLY=( $(compgen -W "-v ${subcmds}" -- ${cur}) )
  elif [[ $prev == -v ]]; then
    COMPREPLY=( $(compgen -W "${subcmds}" -- ${cur}) )
  fi
}