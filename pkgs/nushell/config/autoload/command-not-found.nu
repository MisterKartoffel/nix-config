$env.config.hooks.command_not_found = {|cmd|
  let result = command-not-found $cmd | complete
  $result.stdout + $result.stderr | str trim
}
