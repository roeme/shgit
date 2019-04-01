#shellcheck shell=bash
# functions to keep repo information in the shell
declare -a _shgit_branches
function _shgit_load_branches() {
  git show-ref --heads| mapfile -t _shgit_branches_raw
  for i in "${!_shgit_branches_raw[@]}"; do
    _shgit_branches[$i]="${_shgit_branches_raw[$i]##*/}"
  done
}