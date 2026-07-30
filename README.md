# MisterKartoffel's Nix Flake
![Farmer](https://preview.redd.it/dave-brandt-the-farmer-in-it-aint-much-but-its-honest-work-v0-g1hbw4alq91b1.jpg?width=640&crop=smart&auto=webp&s=b8b9b1c42445d9bd2d0276e61da380cbaaf38fe9)

## Directory Structure Reference
- `flake.nix` - entrypoint for all host and user configurations.
- `shell.nix` - development shell for this flake. Accessible via `nix develop` and `callPackage`-able.
- `.tack` - uses [tack](https://github.com/manic-systems/tack) for input pinning.

- `hosts/<hostname>/` - host-specific NixOS configuration.
  - `default.nix` - host entrypoint and default options.
  - `facter.json` - hardware configuration generated with [NixOS Facter](https://github.com/nix-community/nixos-facter).
  - `disko.nix` - declarative disk layout and formatting using [Disko](https://github.com/nix-community/disko).

- `users/` - user-specific settings. Sourced by `hjem` in `modules/nixos/users.nix`.
  - `<username>.nix` - user entrypoint and default options.

- `modules/` - reusable modules shared across users and hosts.
  - `hjem/` - hjem modules.
  - `hosts/` - NixOS modules.
  - notable modules:
    - [Impermanence](https://github.com/nix-community/impermanence), state persistence;
    - [sops-nix](https://github.com/mic92/sops-nix), declarative secret management;

- `lib/` - custom functions to be used throughout the configuration. Accessible via `lib.custom`.
- `pkgs/` - wrapped standalone packages.
- `overlays/` - importable nixpkgs overlays.

## TODO
- Install and configure:
  - [Newsboat](https://github.com/newsboat/newsboat).

## Acknowledgments
- [Bvngee](https://github.com/bvngee) and [Soi](https://github.com/soulsoiledit), for being a part of TMC and indirectly exposing me to their Nix flakes.
- [EmergentMind](https://github.com/EmergentMind), for being a great reference both on YouTube and on GitHub when it comes to learning Nix and for showing the configuration structure from which I ultimately stole.
- The [Ghostty](https://discord.gg/ghostty) and [Nix/NixOS (Unofficial)](https://discord.com/invite/RbvHtGa) Discord servers for many references.
