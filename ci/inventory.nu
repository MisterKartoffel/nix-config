# Inspired by the work done by wimpysworld in:
# https://github.com/wimpysworld/nix-config/blob/main/home-manager/_mixins/scripts/flake-inventory/flake-inventory.sh

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
    nix eval $"($FLAKE_DIR)#($output)" --apply "builtins.attrNames" --json e> /dev/null
    | str trim
    | from json
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

  if not ($GITHUB_OUTPUT | is-empty) {
    $"($name)=($serialized)\n" | save --append $GITHUB_OUTPUT
  }

  log_debug $"($name) = ($serialized)"
}

log_info $"Discovering flake outputs..."

def discover_outputs [output: string] {
  discover_names $output
  | par-each { |system|
    let runner = get_runner $system
    if ($runner == null) {
      []
    } else {
      let names = discover_names $"($output).($system)"
      if ($names | length) == 0 {
        []
      } else {
        $names | par-each { |name|
          let drv = $"($FLAKE_DIR)#($output).($system).($name)"
          let drv_path = (nix_eval $"($drv).drvPath")
          if ($drv_path | is-empty) {
            null
          } else {
            {
              name: (nix_eval $"($drv).name")
              system: $system
              runner: $runner
              drvPath: $drv_path
            }
          }
        }
      }
    }
  }
  | flatten
  | compact
}

def discover_hosts [platform: string] {
  discover_names $platform
  | par-each { |name|
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
  }
  | compact
}

let tasks = [
  {name: "devshells", type: "derivation", target: "devShells"}
  {name: "packages", type: "derivation", target: "packages"}
  {name: "nixos", type: "host", target: "nixosConfigurations"}
  {name: "darwin", type: "host", target: "darwinConfigurations"}
]

let results = $tasks | par-each { |task|
  let data = if $task.type == "derivation" {
    discover_outputs $task.target
  } else {
    discover_hosts $task.target
  }

  let count = if $task.type == "derivation" {
    $data | get -o name | default [] | uniq | length
  } else {
    ($data | length)
  }

  log_info $"Found ($count) ($task.target)."
  emit_output $task.name $data

  $data
} | flatten

print "󰄬 Inventory complete."

if (($env.HESTIA_BIN? | default "") != "") and (($env.HESTIA_SOCKET? | default "") != "") {
  let drv_paths = $results | get -o drvPath | compact | uniq
  if not ($drv_paths | is-empty) {
    log_info $"Registering ($drv_paths | length) input closure uploads with Hestia..."
    ^$env.HESTIA_BIN hook --socket $env.HESTIA_SOCKET ...$drv_paths
    print "󰄬 Registration complete."
  }
}
