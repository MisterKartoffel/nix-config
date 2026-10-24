use std/config *

$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []
$env.config.hooks.env_change.PWD ++= [
  {||
    if (which direnv | is-empty) { return }
    direnv export json | from json | default {} | update cells --columns [PATH] {
      do (env-conversions).path.from_string $in
    } | load-env
  }
]
