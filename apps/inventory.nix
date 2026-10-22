# Inspired by the work done by wimpysworld in:
# https://github.com/wimpysworld/nix-config/blob/main/home-manager/_mixins/scripts/flake-inventory/flake-inventory.sh
{
  # keep-sorted start

  jq,
  lib,
  nix,
  nix-eval-jobs,
  writers,

  # keep-sorted end
}:
writers.writeNuBin "inventory.nu"
  {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [
        # keep-sorted start

        jq
        nix
        nix-eval-jobs

        # keep-sorted end
      ])
    ];
  }
  /* nu */ ''
    let FLAKE_DIR = ($env.FLAKE_DIR? | default ".")
    let VERBOSE = ($env.INVENTORY_VERBOSE? | default "0") == "1"
    let GITHUB_OUTPUT = ($env.GITHUB_OUTPUT? | default "")

    const RUNNER_MAP = {
      "x86_64-linux": "ubuntu-latest"
      "aarch64-linux": "ubuntu-24.04-arm"
      "aarch64-darwin": "macos-latest"
    }

    const PLATFORMS = [ "x86_64-linux", "aarch64-linux" ]

    def log_info [msg: string] {
      print $"󰙎: ($msg)"
    }

    def log_success [msg: string] {
      print $"󰄬: ($msg)"
    }

    def log_debug [msg: string] {
      if $VERBOSE {
        print $": ($msg)"
      }
    }

    def discover_names [attr_path: string] {
      let full_path = $"($FLAKE_DIR)#($attr_path)"
      try {
        let res = (nix eval $"($FLAKE_DIR)#($attr_path)" --apply "builtins.attrNames" --json e> /dev/null)
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
      nix eval $expr --raw e> /dev/null
    }

    def emit_output [name: string, value: any] {
      let serialized = $value | to json --raw
      if not ($GITHUB_OUTPUT | is-empty) {
        $"($name)=($serialized)\n" | save --append $GITHUB_OUTPUT
      } else {
        print $"[OUTPUT] ($name) = ($serialized)"
      }
    }

    log_info $"Discovering flake outputs."

    def discover_outputs [category: string] {
      $PLATFORMS | reduce --fold [] { |system, acc|
        log_debug $"Evaluating ($FLAKE_DIR)#($category).($system)"

        let runner = get_runner $system
        if ($runner == null) { return $acc }
        let target = $"($FLAKE_DIR)#($category).($system)"

        let rows = (try {
          nix-eval-jobs --flake $target
          | lines
          | each { try { from json } catch { null } }
          | compact
          | where drvPath? != null and name? != null
          | select name drvPath
          | each { |it|
            {
              name: $it.name
              system: $system
              runner: $runner
              drvPath: $it.drvPath
            }
          }
        } catch {
          []
        })

        $acc | append $rows
      }
    }

    def discover_hosts [platform: string] {
      let names = discover_names $platform
      log_info $"Found ($names | length) ($platform)"

      $names | reduce --fold [] { |name, acc|
        if ($name | is-empty) { return $acc }
        let drv = $"($FLAKE_DIR)#($platform).($name)"

        let system = (try {
          nix eval $"($drv).pkgs.stdenv.hostPlatform.system" --raw e> /dev/null
        } catch {
          "unknown"
        })

        let runner = get_runner $system
        if ($runner == null) { return $acc }

        let drv_path = (nix eval $"($drv).config.system.build.toplevel.drvPath" --raw e> /dev/null)
        if ($drv_path | is-empty) { return $acc }

        $acc | append {
          name: $name
          system: $system
          runner: $runner
          drvPath: $drv_path
        }
      }
    }

    log_info "Discovering devShells..."
    let devshells_json = discover_outputs "devShells"
    let unique_shells = if ($devshells_json | is-empty) { 0 } else { $devshells_json | get name | uniq | length }
    log_info $"Found ($unique_shells) devShells."

    log_info "Discovering packages..."
    let packages_json = discover_outputs "packages"
    let unique_packages = if ($packages_json | is-empty) { 0 } else { $packages_json | get name | uniq | length }
    log_info $"Found ($unique_packages) packages."

    log_info "Discovering systems..."
    let nixos_json = discover_hosts "nixosConfigurations"
    let darwin_json = discover_hosts "darwinConfigurations"

    log_info "Emitting GitHub Actions outputs..."
    emit_output "devShells" $devshells_json
    emit_output "packages" $packages_json
    emit_output "nixos" $nixos_json
    emit_output "darwin" $darwin_json

    print ""
    print "============================"
    print " Summary "
    print "============================"
    print $" devShells: ($unique_shells)"
    print $" packages:  ($unique_packages)"
    print $" nixos:     ($nixos_json | length)"
    print $" darwin:    ($darwin_json | length)"
    print "============================"
    print ""

    log_success "Inventory complete."
  ''
