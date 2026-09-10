let
  /*
    Imports default.nix, which is a flake-compat wrapper for flake.nix.

    This avoids having to pass an absolute path to builtins.getFlake,
    at the cost of having to fetch edolstra/flake-compat during the job.
  */
  flake = import ../.;

  runners = {
    x86_64-linux = "ubuntu-latest";
    aarch64-linux = "ubuntu-24.04-arm";
    aarch64-darwin = "macos-latest";
  };

  platforms = map (platform: platform + "Configurations") [
    "nixos"
    "darwin"
  ];

  # Helper for merging information common to all jobs into each output.
  matrix = drv: rec {
    inherit (drv) name drvPath system;
    runner = runners.${system} or (abort "No runner defined for ${system}");
  };

  # Creates the job matrix for GitHub actions for a given flake output.
  jobs =
    outputs:
    builtins.concatMap (
      system: map (drv: matrix outputs.${system}.${drv}) (builtins.attrNames outputs.${system})
    ) (builtins.attrNames outputs);
in
/*
  All these outputs are composed by the common attributes (set by the matrix function):
  - name: the derivation's name, used in GitHub for jobs' names.
  - drvPath: the derivation's path (package, shell, or configuration).
  - system: architecture + kernel string, used to map builds to runners.
  - runner: GitHub Actions runner, used in 'runs-on' for each of the matrix's jobs.
*/
{
  shells = jobs flake.devShells;
  packages = jobs flake.packages;

  hosts = builtins.concatMap (
    platform:
    map (
      hostname:
      (matrix flake.${platform}.${hostname}.config.system.build.toplevel)
      // {
        inherit hostname;
      }
    ) (builtins.attrNames (flake.${platform} or { }))
  ) platforms;
}
