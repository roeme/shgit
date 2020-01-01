#shellcheck shell=bash
# functions to keep repo information in the shell
declare -a _shgit_branches
function _shgit_load_branches() {
  mapfile -t _shgit_branches < <(git show-ref --heads)
}

declare -a _shgit_remotes
function _shgit_load_remotes() {
  mapfile -t _shgit_remotes < <(git remote)
}