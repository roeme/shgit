function _shgit_load_settings() {
  _shgit_init_msg "Reading shgit specific settings..."
  _shgit_trunc_symbol="$(git config shgit.trunc-symbol 2> /dev/null || echo "…")"
  _shgit_pwd_max_len="$(git config shgit.pwd-max-len 2> /dev/null || echo 20)"
  _sghit_prompt_mode="$(git config shgit.prompt-command-mode 2> /dev/null || echo override)"
}