# MisterKartoffel's Nix Flake
![Farmer](https://preview.redd.it/dave-brandt-the-farmer-in-it-aint-much-but-its-honest-work-v0-g1hbw4alq91b1.jpg?width=640&crop=smart&auto=webp&s=b8b9b1c42445d9bd2d0276e61da380cbaaf38fe9)

## Directory Structure Reference
- `flake.nix` - entrypoint for all host configurations. Ultimately redefines `nixosConfigurations` to a custom structure adapted to this repository's own.
- `home/<username>/` - defines Home-Manager settings on a per-user basis.
  - `keys/` - authorized SSH keys for remote access to this user.
- `hosts/<hostname>/` - defines NixOS settings on a per-host basis.
  - `metadata.nix` - stores <hostname>'s definitions for `config.hostSpec`, as well as the list of users to be created under `config.hostSpec.userList` - Is sourced by `flake.nix` directly, not by `default.nix`.
- `lib/` - defines useful library functions to be used throughout the configuration. Accessible via `lib.custom`.
- `modules/` - defines all modules in all scopes for all users and all hosts.
  - `flake/` - modules used by `flake.nix` directly.
  - `home/` - main path for all Home-Manager modules.
    - `core/` - Home-Manager modules used across all users.
    - `optional/` - Home-Manager modules used across at least one but not all users.
  - `hosts/` - holds all NixOS modules.
    - `core/` - NixOS modules used across all hosts.
    - `optional/` - NixOS modules used across at least one but not all hosts.

## TODO
- Install and configure:
  - [just](https://github.com/casey/just).
  - [Vesktop](https://github.com/Vencord/Vesktop).
  - [Newsboat](https://github.com/newsboat/newsboat).
- Configure dunst to not be an ugly mess.
- Look into moving sops and age out of environment.systemPackages and into nix-secrets devShell.

## Acknowledgments
- [Bvngee](https://github.com/bvngee) and [Soi](https://github.com/soulsoiledit), for being a part of TMC and indirectly exposing me to their Nix flakes.
- [EmergentMind](https://github.com/EmergentMind), for being a great reference both on YouTube and on GitHub when it comes to learning Nix and for showing the configuration structure from which I ultimately stole.
