# MisterKartoffel's Nix Flake
![it_aint_much](assets/it_aint_much.jpg)

## Directory Structure Reference
```
flake/
├── .tack/
├── hosts/
│   └── <hostname>/
│       ├── default.nix
│       ├── disko.nix
│       ├── facter.json
│       └── ...
├── users/
│   └── <username>/
│       ├── default.nix
│       └── ...
├── modules/
│   ├── hjem/
│   └── nixos/
├── pkgs/
│   ├── nvim/
│   └── zen-browser/
├── overlays/
│   └── default.nix
├── lib/
├── default.nix
├── flake.nix
├── shell.nix
├── treefmt.nix
├── LICENSE
└── README.md
```

## Notable modules and dependencies
#### [manic-systems/tack](https://github.com/manic-systems/tack) - input pinning.
#### [nix-community/disko](https://github.com/nix-community/disko) - declarative disk management.
#### [nix-community/nixos-facter](https://github.com/nix-community/nixos-facter) - generated hardware configuration.
#### [nix-community/preservation](https://github.com/nix-community/preservation) - state persistence.
#### [mic92/sops-nix](https://github.com/mic92/sops-nix) - declarative secret management.

## TODO
- Install and configure:
  - [Newsboat](https://github.com/newsboat/newsboat).

## Acknowledgments
- [Bvngee](https://github.com/bvngee) and [Soi](https://github.com/soulsoiledit), for being a part of TMC and indirectly exposing me to their Nix flakes.
- [EmergentMind](https://github.com/EmergentMind), for being a great reference both on YouTube and on GitHub when it comes to learning Nix and for showing the configuration structure from which I ultimately stole.
- The [Ghostty](https://discord.gg/ghostty) and [Nix/NixOS (Unofficial)](https://discord.com/invite/RbvHtGa) Discord servers for many references.
