#!/bin/bash
# The $shg_colors variable is a named array which holds color codes for
# various things. if possible, these use git standard colors.
function _shgit_setup_palette() {
  _shgit_init_msg "Setting up color palette..."
  _get_colors_default=(
    'reponame        208 234'
    'currentbranch   034'
    'pwd             250'
    'prompt          254 0'
    )
  ANSI_RESET="\001$(git config --get-color "" "reset")\002"
  declare -Ag shg_colors
  _shgit_init_msg "Reading color escapes from git..."
  for defaultcol_entry in "${_get_colors_default[@]}"; do
    read -r colsetting default_color <<< $defaultcol_entry
    shg_colors[${colsetting}]="\001$(git config --get-color color.shgit.${colsetting} "${default_color}")\002"
  done
  unset _get_colors_default
}