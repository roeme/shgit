#!/bin/bash
set -eu
unameOut="$(uname -s)"
case "${unameOut}" in
  Darwin*)    readlink=greadlink;;
  *BSD*)      readlink=greadlink;;
  *)          readlink=readlink;;
esac
myloc="$($readlink -f "$(dirname "$0")")" || {
  echo 'need GNU coreutils!'
  exit 1
}
# TODO: be friendly to people who use repo'ed dotfiles across multiple machines
# with differing user names and/or homedir paths
# this requires adjusting $myloc. hmm.
usage() {
  echo "Usage: install.sh install|uninstall"
  echo "Adjusts your global git config so you can use shgit"
}

case ${1:-} in
  install)
    git config --global alias.sh "!'$myloc/shgit.sh'"
    echo "added alias 'sh' to your global git config."

    git config --global shgit.location "$myloc"
    echo "configured shgit location in global config as '${myloc}'"

    echo "You can invoke the shell via 'git sh' from within a repo."
    ;;

  uninstall)

    git config --global --unset alias.sh || true
    echo "Removed alias 'sh' from your global git config."

    git config --global --unset shgit.location || true
    echo "Removed 'shgit.location' from your global git config."

    ;;
  *|-h)
    usage
    ;;
esac
