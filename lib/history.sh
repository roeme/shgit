#shellcheck shell=bash
# TODO: make history specific per repo
function _shgit_adjust_history() {
  [[ "$(git config shgit.separate-histfile 2> /dev/null || echo true)" = true ]] || return
  [[ -n "${HISTFILE:-}" || return ]]
  _shgit_init_msg "adjusting history settings"
  export HISTFILE=${HISTFILE}.shgit
  history -c && history -r
}
_shgit_adjust_history