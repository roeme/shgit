#!/bin/bash
function in_array() {
  local -n arr=$1
  for item in "${arr[@]}"; do
    [[ "${item}" = "${2}" ]] && return 0
  done
  return 1
}
function _shgit_init_msg() {
  [[ "${_shgit_quiet_init:-,,}" = true ]] || _shgit_msg "$1"
}
function _shgit_msg() {
  echo -e "$1" >&2
}
function _shgit_warn_msg() {
  _shgit_msg "\\e[33mWarning:\\e[39m $1"
}

function _shgit_die() {
  _shgit_msg "\\e[31mFail:\\e[39m $1"
  exit 1
}

#shellcheck disable=SC1091
function _shgit_read_userbashrc {
  [[ -r ~/.bashrc ]] && {
    _shgit_init_msg "Loading your ~/.bashrc"
    # the pushd/popd is done on purpose. user's bashrc might rely on it...
    # TODO: make bashrc loading configurable
    pushd ~ > /dev/null || _shgit_die "Can't change to your homedir for some reason?!"
    . .bashrc
    popd > /dev/null || _shgit_die "Couldn't restore original shgit directory?!"
  }
}