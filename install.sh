#!/bin/bash
set -eu
myloc="$(readlink -f "$(dirname "$0")")"
usage() {
  echo "Usage: install.sh install|uninstall"
}
case ${1:-} in
  install)
    git config --global alias.sh "!'$myloc/shgit.sh'"
    echo "added alias 'sh' to your global git config."
    [[ -d "${HOME}/.libexec" ]] || {
      mkdir "${HOME}/.libexec"
      echo 'created "${HOME}/.libexec'
    }
    ln -s "$myloc/completions" "${HOME}/.libexec/shgit_completions"
    ;;
  uninstall)
    rm -r "${HOME}/.libexec/shgit_completions"
    echo "Removed ${HOME}/.libexec/shgit_completions"
    git config --global --unset alias.sh
    echo "Removed alias 'sh' from your global git config"
    ;;
  *|-h)
    usage
    ;;
esac