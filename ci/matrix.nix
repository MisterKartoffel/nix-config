let
  flake = import ../.;

  runners = {
    x86_64-linux = "ubuntu-latest";
    aarch64-linux = "ubuntu-24.04-arm";
    aarch64-darwin = "macos-latest";
  };

  platforms = [
    "nixos"
    "darwin"
  ];

  hosts = builtins.concatMap (
    platform:
    map (name: {
      inherit name;
      inherit (flake."${platform}Configurations".${name}.pkgs.stdenv.hostPlatform) system;
    }) (builtins.attrNames (flake."${platform}Configurations" or { }))
  ) platforms;

  systems = builtins.mapAttrs (system: hosts: {
    inherit system;
    inherit hosts;
    devShells = builtins.attrNames (flake.devShells.${system} or { });
    packages = builtins.attrNames (flake.packages.${system} or { });
    runner = runners.${system} or (abort "No runner defined for ${system}");
  }) (builtins.groupBy (host: host.system) hosts);
in
{
  shells = builtins.concatMap (
    system:
    map (shell: {
      inherit shell system;
      runner = systems.${system}.runner;
    }) systems.${system}.devShells
  ) (builtins.attrNames systems);

  hosts = builtins.concatMap (
    system:
    map (host: {
      hostname = host.name;
      inherit (host) system;
      runner = systems.${system}.runner;
    }) systems.${system}.hosts
  ) (builtins.attrNames systems);

  packages = builtins.concatMap (
    system:
    map (package: {
      inherit package system;
      runner = systems.${system}.runner;
    }) systems.${system}.packages
  ) (builtins.attrNames systems);
}
