let
  /*
    Imports default.nix, which is a flake-compat wrapper for flake.nix.

    This avoids having to pass an absolute path to builtins.getFlake,
    at the cost of having to fetch edolstra/flake-compat during the job.
  */
  flake = import ../.;

  /*
    Since this matrix generator is host-centric, it maps each existing
    pkgs.stdenv.hostPlatform.system to its GitHub Actions runner
  */
  runners = {
    x86_64-linux = "ubuntu-latest";
    aarch64-linux = "ubuntu-24.04-arm";
    aarch64-darwin = "macos-latest";
  };

  /*
    Creates an attribute set of hosts by system architecture, dinamically
    fetched from the nixosConfigurations and darwinConfigurations flake outputs.
  */
  platforms = [
    "nixos"
    "darwin"
  ];

  hosts = builtins.concatMap (
    platform:
    map (hostname: {
      inherit hostname platform;
      inherit (flake."${platform}Configurations".${hostname}.pkgs.stdenv.hostPlatform) system;
    }) (builtins.attrNames (flake."${platform}Configurations" or { }))
  ) platforms;

  systems = builtins.groupBy (host: host.system) hosts;

  # Helper for merging information common to all jobs into each output.
  matrix = system: {
    inherit system;
    runner = runners.${system} or (abort "No runner defined for ${system}");
  };
in
/*
  All these outputs are composed by the common attributes:
  - system: architecture + kernel string, used for outputs keyed by system.
  - runner: GitHub Actions runner, used in 'runs-on' for each of the matrix's jobs.

  devShells, packages and hosts have unique "shell", "package", and "hostname"
  attributes, respectively, for identifying the flake output when built.

  Hosts have the unique attribute "platform", for composing the build command
  in the runner's build job.
*/
{
  shells = builtins.concatMap (
    system:
    map (shell: (matrix system) // { inherit shell; }) (
      builtins.attrNames (flake.devShells.${system} or { })
    )
  ) (builtins.attrNames systems);

  packages = builtins.concatMap (
    system:
    map (package: (matrix system) // { inherit package; }) (
      builtins.attrNames (flake.packages.${system} or { })
    )
  ) (builtins.attrNames systems);

  hosts = builtins.concatMap (
    system:
    map (
      host:
      (matrix system)
      // {
        inherit (host) hostname platform;
      }
    ) systems.${system}
  ) (builtins.attrNames systems);
}
