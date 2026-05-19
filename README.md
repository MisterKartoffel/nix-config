# MisterKartoffel's Nix Flake
![Farmer](https://preview.redd.it/dave-brandt-the-farmer-in-it-aint-much-but-its-honest-work-v0-g1hbw4alq91b1.jpg?width=640&crop=smart&auto=webp&s=b8b9b1c42445d9bd2d0276e61da380cbaaf38fe9)

## Directory Structure Reference
- `flake.nix` - entrypoint for all host and user configurations.

- `hosts/<hostname>/` - defines NixOS settings and users on a per-host basis.
  - `default.nix` - host entrypoint, sets default options.
  - `facter.json` - hardware configuration setup with [NixOS Facter](https://github.com/nix-community/nixos-facter).
  - `disko.nix` - declarative disk configuration using [Disko](https://github.com/nix-community/disko).
  - `impermanence.nix` - configures persistent system directories for [Impermanence](https://github.com/nix-community/impermanence).

- `home/<username>/` - defines Home-Manager settings on a per-user basis.
  - `default.nix` - user entrypoint, sets default options.
  - `impermanence.nix` - configures persistent user directories for [Impermanence](https://github.com/nix-community/impermanence).
  - `keys/` - authorized SSH keys for remote access to this user.

- `modules/` - defines all modules in all scopes for all users and all hosts.
  - `flake/` - modules used by `flake.nix` directly.
  - `home/` - main path for all Home-Manager modules.
    - `subdirectories` - hold module bundles (Mail, Neovim, etc.) if any.
  - `hosts/` - holds all NixOS modules.
    - `subdirectories` - hold module bundles if any.

- `lib/` - defines useful library functions to be used throughout the configuration. Accessible via `lib.custom`.

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
- The [Ghostty](https://discord.gg/ghostty) and [Nix/NixOS (Unofficial)](https://discord.com/invite/RbvHtGa) Discord servers for many references.
