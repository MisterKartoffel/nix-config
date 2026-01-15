# MisterKartoffel's Nix Flake
![Farmer](https://preview.redd.it/dave-brandt-the-farmer-in-it-aint-much-but-its-honest-work-v0-g1hbw4alq91b1.jpg?width=640&crop=smart&auto=webp&s=b8b9b1c42445d9bd2d0276e61da380cbaaf38fe9)

## Directory Structure Reference
- `flake.nix` - entrypoint for all host configurations. Ultimately redefines `nixosConfigurations` to a custom structure adapted to this repository's own.
- `home` - defines home-manager modules on a per-user basis.
  - `<username>` - stores home-manager modules on a per-user basis.
    - `default.nix` - entrypoint for this user's home-manager modules and configurations.
  - `common` - stores modules shared among hosts.
    - `core` - configurations common to all users.
    - `optional` - configurations common to more than one, but not all, users.
- `hosts` - defines NixOS modules on a per-host basis.
  - `<hostname>` - contains modules exclusive to that host.
    - `default.nix` - entrypoint for this host's NixOS modules and configurations.
    - `metadata.nix` - stores <hostname>'s definitions for `config.hostSpec`, as well as the list of users to be created under `config.hostSpec.userList` - Is sourced by `flake.nix` directly, not by `default.nix`.
  - `common` - stores modules shared among hosts.
    - `core` - configurations common to all hosts.
      - `users.nix` - entrypoint for user creation on a given host using `config.hostSpec.userList` derived from `<hostname>/metadata.nix`.
    - `optional` - configurations to be present among more than one, but not all, hosts.
- `lib` - defines useful library functions to be used throughout the configuration. Accessible via `lib.custom`.
- `modules` - defines the options and defaults for `config.homeSpec`.

## Acknowledgments
- [Bvngee](https://github.com/bvngee) and [Soi](https://github.com/soulsoiledit), for being a part of TMC and indirectly exposing me to their Nix flakes.
- [EmergentMind](https://github.com/EmergentMind), for being a great reference both on YouTube and on GitHub when it comes to learning Nix and for showing the configuration structure from which I ultimately stole.
