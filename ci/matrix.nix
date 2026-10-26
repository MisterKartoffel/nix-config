let
  flake = builtins.getFlake (toString ../.);

  runners = {
    x86_64-linux = "ubuntu-latest";
    aarch64-linux = "ubuntu-24.04-arm";
    aarch64-darwin = "macos-latest";
  };

  # Helper for merging information common to all jobs into each output.
  parse = drv: {
    inherit (drv) drvPath system;
    runner = runners.${drv.system} or (abort "No runner defined for ${drv.system}");
  };
in
/*
  All these outputs are composed by the common attributes (set by the matrix function):
  - name: hostname, used in GitHub for jobs' names.
  - drvPath: host's derivation path.
  - system: architecture + kernel string, used to map builds to runners.
  - runner: GitHub Actions runner, used in 'runs-on' for each of the matrix's jobs.
*/
builtins.concatMap
  (
    platform:
    map (name: (parse flake.${platform}.${name}.config.system.build.toplevel) // { inherit name; }) (
      builtins.attrNames (flake.${platform} or { })
    )
  )
  [
    "nixosConfigurations"
    "darwinConfigurations"
  ]
