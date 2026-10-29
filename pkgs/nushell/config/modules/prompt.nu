def __pure_ssh [separator: string = "@"]: nothing -> string {
  if ($env.SSH_CLIENT? != null) or ($env.SSH_TTY? != null) {
    let user: string = $env.USER? | default (whoami)
    let host: string = sys host | get hostname
    $"(ansi black)($user)($separator)($host)(ansi reset)"
  } else {
    ""
  }
}

def __pure_cwd []: nothing -> string {
  let path = $env.PWD | str replace $env.HOME "~"
  $"(ansi blue)($path)(ansi reset)"
}

def __pure_git_status []: nothing -> string {
  let branch: string = (
    do -i { git branch --show-current }
    | complete
    | get stdout
    | str trim
  )
  if $branch == "" { return "" }

  let dirty: string = if (
    do -i { git status --porcelain --untracked-files=no }
    | complete
    | get stdout
    | str trim
  ) != "" { "*" } else { "" }

  let counts: record<stdout: string, stderr: string, exit_code: int> = do -i { git rev-list --left-right --count "HEAD...@{upstream}" } | complete

  let indicators: string = if $counts.exit_code == 0 {
    let parts: list<string> = $counts.stdout | str trim | split row --regex '\s+'
    let count: record<ahead: int, behind: int> = {
      ahead: (
        if ($parts | length) > 0 {
          $parts.0 | into int
        } else {
          0
        }
      )
      behind: (
        if ($parts | length) > 1 {
          $parts.1 | into int
        } else {
          0
        }
      )
    }

    let ahead: string = if $count.ahead > 0 { "⇡" } else { "" }
    let behind: string = if $count.behind > 0 { "⇣" } else { "" }
    $"($ahead)($behind)"
  } else {
    ""
  }

  $"(ansi black)($branch)($dirty) (ansi cyan)($indicators)(ansi reset)"
}

def __pure_nix_shell [symbol: string = "󱄅"]: nothing -> string {
  if $env.IN_NIX_SHELL? != null {
    let name: string = $env.name? | str replace "-env" ""
    $"(ansi cyan)($symbol) ($name)(ansi reset) "
  } else {
    ""
  }
}

def __pure_current_time [format: string = "%H:%M"]: nothing -> string {
  let current_time: string = date now | format date $format
  $"(ansi black)($current_time)(ansi reset)"
}

def __pure_command_duration [minimum: duration = 2sec]: nothing -> string {
  let elapsed: duration = ($env.CMD_DURATION_MS? | default 0 | into int) * 1ms

  if $elapsed > $minimum {
    $"(ansi yellow)($elapsed)(ansi reset)"
  } else {
    ""
  }
}

def __pure_indicator [symbol: string]: nothing -> string {
  let color: string = if $env.LAST_EXIT_CODE? == 0 {
    (ansi magenta)
  } else {
    (ansi red)
  }

  $"($color)($symbol)(ansi reset)"
}

export-env {
  $env.PROMPT_COMMAND = {||
    let ssh: string = (__pure_ssh)
    let cwd: string = (__pure_cwd)
    let git: string = (__pure_git_status)
    let top: string = [$ssh, $cwd, $git] | str join (char space) | str trim

    let nix: string = (__pure_nix_shell)
    let bottom: string = $nix

    [$top, $bottom] | str join (char newline)
  }

  $env.PROMPT_COMMAND_RIGHT = {||
    let time: string = (__pure_current_time)
    let duration: string = (__pure_command_duration)

    [$time, $duration] | str join (char space)
  }

  $env.PROMPT_INDICATOR = $env.PROMPT_INDICATOR_VI_INSERT
  $env.PROMPT_INDICATOR_VI_INSERT = {|| __pure_indicator "󰅂 " }
  $env.PROMPT_INDICATOR_VI_NORMAL = {|| __pure_indicator "󰅁 " }
  $env.PROMPT_MULTILINE_INDICATOR = {|| __pure_indicator "󰄾 " }

  $env.TRANSIENT_PROMPT_COMMAND = {|| "" }
  $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
  $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
  $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
}
