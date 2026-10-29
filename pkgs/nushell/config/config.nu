# Modules
use prompt.nu *

# History
$env.config.history.file_format = "Sqlite"
$env.config.history.path = ($env.XDG_DATA_HOME | path join "nushell")

# Terminal settings
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"
$env.config.footer_mode = "auto"
$env.config.highlight_resolved_externals = true
$env.config.show_banner = false
$env.config.table.header_on_separator = true
$env.config.table.show_empty = false
$env.config.use_kitty_protocol = true

# Completions
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.persistent_menus = true

$env.config.hinter.closure = {|ctx: record<line: string, cwd: string, pos: int>|
  if ($ctx.line | is-empty) { return null }

  let global: bool = ($env.LOCAL_COMPLETIONS? | default 1) == 0 or ($ctx.line | str starts-with "$env.")

  let sql: string = if $global {
    "SELECT command_line, exit_status FROM history WHERE substr(command_line, 1, :len) = :line ORDER BY id DESC LIMIT 1"
  } else {
    "SELECT command_line, exit_status FROM history WHERE substr(command_line, 1, :len) = :line ORDER BY cwd = :cwd DESC, id DESC LIMIT 1"
  }

  let params: record<len: int, line: string, cwd: oneof<string, nothing>> = {
    len: ($ctx.line | str length)
    line: $ctx.line
    cwd: (if $global { null } else { $ctx.cwd })
  }

  let row: oneof<record<command_line: string, exit_status: int>, nothing> = open $nu.history-path
  | query db $sql --params $params
  | get --optional 0

  if $row == null { return null }

  let candidate: string = $row.command_line | str replace --regex ' #exit_\d+$' ""
  let exit_code: int = $row.exit_status | default 0
  let tag: string = if $exit_code >= 1 { $" #exit_($exit_code)" } else { "" }

  let hint: string = $"($candidate | str substring ($ctx.line | str length)..)($tag)"

  if $hint == "" { null } else { $hint }
}
