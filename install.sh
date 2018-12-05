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

    git config --global --unset alias.sh
    echo "Removed alias 'sh' from your global git config."

    git config --global shgit.location "$myloc"
    echo "Removed 'shgit.location' from your global git config."

    ;;
  *|-h)
    usage
    ;;
esac
