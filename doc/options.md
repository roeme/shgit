### SHGIT CONFIGURATION OPTIONS

The following options are available in `[shgit]`:

* `quiet_init` (Boolean, Default false):

    Don't print initialization messages.

* `suppress_keyword_alert` (Boolean, Default false):

    If your aliases include a shell keyword, shgit will warn upon this and won't
    make the alias available at top-level. This setting will suppress the message.

* `pwd-max-len` (Int, Default 20):

    Maximum length of working directory to display in prompt (longer will be
    truncated).

* `trunc-symbol` (String, Default "…"):

    Truncation character to be used for working directory display when 'prompt-command-mode' is set to "override".

* `prompt-command-mode` (Enum, Default "override"):

    Tells `shgit` how to modify the prompt.

    * `override`:
        Use shgit's standard prompt.

    * `stealthy`:
        Simply prepend ps1-prefix to `$PS1` to indicate shgit. If `PROMPT_COMMAND`
        is set, it will be modified by shgit to make sure `$PS1` is adjusted.

    * `no-touchy`:
        Instructs to shgit to not touch `$PROMPT_COMMAND` at all and leave your
    original setting intact. Make sure you don't get confused when using this,
    as depending on your settings there might be no visual indication that the
    shell environment has been modified (You'll probably want `stealthy`
    instead).

    * `custom`:
        Run a completely custom `$PROMPT_COMMAND`, set in `custom-prompt-command`.
    If you want to implement your own custom prompt, have a look at the internal
    function `shgit_prompt_cmd` to cherry-pick whatever you need.

    The settings `stealthy` and `no-touchy` will stop shgit from executing _any_
    git commands whatsoever when prompting the user, rendering the shell even
    faster. When using `custom`, that is up to you, naturally.

* `ps1-prefix` (String, Default "🐚 "):

    Custom prefix that gets prepended to "$PS1" when `prompt-command-mode` is
    set to `stealthy`.

* `custom-prompt-command` (String, Default unset):

    Custom `$PROMPT_COMMAND`. Only read if `prompt-command-mode` has been set to
    `custom`, ignored otherwise.

* `hook-cd` (Boolean, Default false)

    Tells shgit to hook cd, so instead of cwd to $HOME by default when called
    with no args, cwd to the current repo's root instead.

* `verbose-exec` (Boolean, Default false)

    Tells shgit to echo what git commands will be executed. This also expands
    your own git aliases to a certain degree. This is useful for
    teaching&learning git.