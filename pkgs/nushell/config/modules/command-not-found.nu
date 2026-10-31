export def --wrapped main [command: string, ...args: string]: nothing -> record<stdout: string, stderr: string, exit_code: int> {
  if ($command | is-empty) { exit 1 }

  let dbPath: path = "@dbPath@"
  if not ($dbPath | path exists) { return null }

  let system: string = (
    uname
    | get machine kernel-name
    | str join "-"
    | str lowercase
  )

  let res: oneof<table<name: string, system: string, package: string>, nothing> = try {
    (
      open $dbPath
      | get Programs
      | where system == $system and name == $command
    )
  } catch {
    return null
  }

  let len: int = $res | length
  match $len {
    0 => {
      return null
    }
    _ => {
      let intro: string = $"The program '($command)' is not in your PATH."

      let options: string = $"It is provided by (if $len == 1 {
        $"the '($res.0.package)' package."
      } else {
        let list: string = $res
        | each {|row| $"  ($row.package)"}
        | str join (char newline)
        ["any of the following packages:", $list] | str join (char newline)
      })"

      let message: string = [$intro, $options] | str join (char newline)

      return $message
    }
  }
}

export-env {
  $env.config.hooks.command_not_found = {|command|
    main $command
  }
}
