# MisterKartoffel's Nix Flake
![it_aint_much](assets/it_aint_much.jpg)

## Directory Structure Reference
```
flake/
├── .tack/                ◄ [1]
├── hosts/
│   └── <hostname>/
│       ├── default.nix
│       ├── disko.nix     ◄ [2]
│       ├── facter.json   ◄ [3]
│       └── ...
├── users/
│   └── <username>.nix
├── modules/
│   ├── hjem/             ◄ [4]
│   └── nixos/
│       ├── preservation/ ◄ [5]
│       └── sops.nix      ◄ [6]
├── pkgs/
│   ├── fish/
│   ├── nvim/
│   └── zen-browser/      ◄ [7]
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
#### [1] [manic-systems/tack](https://github.com/manic-systems/tack) - input pinning.
#### [2] [nix-community/disko](https://github.com/nix-community/disko) - declarative disk management.
#### [3] [nix-community/nixos-facter](https://github.com/nix-community/nixos-facter) - generated hardware configuration.
#### [4] [feel-co/hjem](https://github.com/feel-co/hjem) - streamlined $HOME management.
#### [5] [nix-community/preservation](https://github.com/nix-community/preservation) - state persistence.
#### [6] [mic92/sops-nix](https://github.com/mic92/sops-nix) - declarative secret management.
#### [7] [youwen5/zen-browser-flake](https://github.com/youwen5/zen-browser-flake) - flake for Zen Browser.

## TODO

## Acknowledgments
- [Bvngee](https://github.com/bvngee) and [Soi](https://github.com/soulsoiledit), for being a part of TMC and indirectly exposing me to their Nix flakes.
- [EmergentMind](https://github.com/EmergentMind), for being a great reference both on YouTube and on GitHub when it comes to learning Nix and for showing the configuration structure from which I ultimately stole.
- The [niri & DMS](https://discord.gg/vT8Sfjy7sx) and [Ghostty](https://discord.gg/ghostty) Discord servers for many references.
