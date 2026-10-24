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

$env.config.hinter.closure = {|ctx|
  if ($ctx.line | is-empty) { return null }

  let global = ($env.LOCAL_COMPLETIONS? | default 1) == 0 or ($ctx.line | str starts-with "$env.")

  let row = open $nu.history-path
  | query db (
      "SELECT command_line, exit_status FROM history
      WHERE substr(command_line, 1, :len) = :line
      ORDER BY"
      + (if $global { "" } else { " cwd = :cwd DESC," })
      + " id DESC LIMIT 1"
    ) --params (
      {len: ($ctx.line | str length) line: $ctx.line}
      | if $global { } else { insert cwd $ctx.cwd }
    )
  | get --optional 0

  if $row == null { return null }

  let candidate = $row.command_line | str replace --regex ' #exit_\d+$' ""
  let tag = $row.exit_status
  | default 0
  | if $in >= 1 { $" #exit_($in)" } else { "" }

  let hint = ($candidate | str substring ($ctx.line | str length)..) + $tag
  if $hint == "" { null } else { $hint }
}
