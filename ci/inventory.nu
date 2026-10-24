let FLAKE_DIR = $env.FLAKE_DIR? | default "."
let VERBOSE = ($env.INVENTORY_VERBOSE? | default "0") == "1"
let GITHUB_OUTPUT = $env.GITHUB_OUTPUT? | default ""

const RUNNER_MAP = {
  "x86_64-linux": "ubuntu-latest"
  "aarch64-linux": "ubuntu-24.04-arm"
}

def log_info [msg: string] {
  print $"󰙎 ($msg)"
}

def log_debug [msg: string] {
  if $VERBOSE {
    print $"󰍉 ($msg)"
  }
}

def discover_names [output: string] {
  try {
    let res = (
      nix eval $"($FLAKE_DIR)#($output)" --apply "builtins.attrNames" --json e> /dev/null
    )
    if ($res | is-empty) {
      []
    } else {
      $res | str trim | from json
    }
  } catch {
    []
  }
}

def get_runner [system: string] {
  $RUNNER_MAP | get -o $system
}

def nix_eval [expr: string] {
  try {
    nix eval $expr --raw e> /dev/null
  } catch {
    ""
  }
}

def emit_output [name: string, value] {
  let serialized = $value | to json --raw
  if $VERBOSE {
    if not ($GITHUB_OUTPUT | is-empty) {
      $"($name)=($serialized)\n" | save --append $GITHUB_OUTPUT
    } else {
      print $" ($name) = ($serialized)"
    }
  }
}

log_info $"Discovering flake outputs..."

def discover_outputs [category: string] {
  let systems = discover_names $category

  $systems | par-each { |system|
    let runner = get_runner $system
    if ($runner == null) {
      []
    } else {
      let attr_names = discover_names $"($category).($system)"
      if ($attr_names | length) == 0 {
        []
      } else {
        $attr_names | par-each { |attr|
          let target_path = $"($FLAKE_DIR)#($category).($system).($attr)"
          let drv_path = (nix_eval $"($target_path).drvPath")
          if ($drv_path | is-empty) {
            null
          } else {
            let name = (nix_eval $"($target_path).name")
            {
              name: $name
              system: $system
              runner: $runner
              drvPath: $drv_path
            }
          } | compact
        }
      }
    }
  } | flatten
}

def discover_hosts [platform: string] {
  let names = discover_names $platform

  let results = ($names | par-each { |name|
    if ($name | is-empty) {
      null
    } else {
      let drv = $"($FLAKE_DIR)#($platform).($name)"
      let system = (try {
        nix_eval $"($drv).pkgs.stdenv.hostPlatform.system"
      } catch {
        "unknown"
      })

      let runner = get_runner $system
      if ($runner == null) {
        null
      } else {
        let drv_path = (nix_eval $"($drv).config.system.build.toplevel.drvPath")
        if ($drv_path | is-empty) {
          null
        } else {
          {
            name: $name
            system: $system
            runner: $runner
            drvPath: $drv_path
          }
        }
      }
    }
  } | compact)

  $results
}

[
  {name: "devshells", type: "derivation", target: "devShells"}
  {name: "packages", type: "derivation", target: "packages"}
  {name: "nixos", type: "host", target: "nixosConfigurations"}
  {name: "darwin", type: "host", target: "darwinConfigurations"}
] | par-each { |task|
  let res = if $task.type == "derivation" {
    discover_outputs $task.target
  } else {
    discover_hosts $task.target
  }

  let count = if $task.type == "derivation" {
    if ($res | is-empty) { 0 } else { $res | get name | uniq | length }
  } else {
    ($res | length)
  }

  log_info $"Found ($count) ($task.target)."
  emit_output $task.name $res
}

print "󰄬 Inventory complete."
