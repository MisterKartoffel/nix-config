let
  hosts = builtins.attrNames (builtins.readDir ../hosts);

  runners = {
    x86_64-linux = "ubuntu-latest";
    aarch64-linux = "ubuntu-24.04-arm";
  };
in
map (
  hostname:
  let
    system =
      (builtins.fromJSON (builtins.readFile ../hosts/${hostname}/facter.json)).system
        or (abort "Missing system for ${hostname}");
  in
  {
    inherit hostname system;
    runner = runners.${system} or (abort "No runner configured for system ${system}");
  }
) hosts
