#shellcheck shell=bash
# functions to keep repo information in the shell
declare -a _shgit_branches
function _shgit_load_branches() {
  git show-ref --heads| mapfile -t _shgit_branches
}

declare -a _shgit_remotes
function _shgit_load_remotes() {
  git remote | mapfile -t _shgit_remotes
}