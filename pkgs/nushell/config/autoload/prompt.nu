def git_prompt [] {
  if (which git | is-empty) { return "" }
  let git_status = (do -i {
    git status --porcelain=v1 e> /dev/null
  } | decode utf-8)

  let git_branch = (do -i {
    git branch --show-current e> /dev/null
  } | decode utf-8 | str trim)

  if ($git_branch | is-empty) { return "" }
  let is_dirty = not ($git_status | is-empty)
  let git_indicator = if $is_dirty { "main*" } else { "main" }

  $"(ansi black) ($git_indicator)(ansi reset)"
}

def nix_prompt [] {
  if ($env | get -o IN_NIX_SHELL | is-empty) { return "" }
  $"\n(ansi cyan) impure (ansi reset)"
}

def duration_prompt [time: int = 2000] {
  if ($env | get -o CMD_DURATION_MS | is-empty) { return "" }
  let duration_ms = $env.CMD_DURATION_MS | into int

  if $duration_ms > $time {
    let duration_sec = $duration_ms / 1000 | math round -p 1
    return $"(ansi yellow) ($duration_sec)s"
  }
  ""
}

def indicator [symbol: string] {
  let color = if $env.LAST_EXIT_CODE == 0 {
    ansi pink1
  } else {
    ansi red_bold
  }

  $"($color)($symbol)(ansi reset)"
}

$env.PROMPT_COMMAND = {||
  let dir = do -i { $env.PWD } | str replace $env.HOME "~"
  let top_line = $"(char newline)(ansi blue)($dir)(git_prompt)"
  let bottom_line = (nix_prompt)

  $"($top_line)($bottom_line)"
}

$env.PROMPT_COMMAND_RIGHT = { duration_prompt }
$env.PROMPT_INDICATOR_VI_INSERT = {|| indicator "❯ " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| indicator " " }
$env.PROMPT_MULTILINE_INDICATOR = {|| indicator "❯❯ " }

$env.TRANSIENT_PROMPT_COMMAND = {|| "" }
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| indicator (do $env.PROMPT_INDICATOR_VI_INSERT) }
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| indicator (do $env.PROMPT_INDICATOR_VI_NORMAL) }
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| indicator (do $env.PROMPT_MULTILINE_INDICATOR) }
