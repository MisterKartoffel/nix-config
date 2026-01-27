{
  hostname = "ghost";
  system = "x86_64-linux";
  stateVersion = "25.11";

  userList = [
    {
      name = "mimikyu";
      shell = "zsh";
      extraGroups = [
        "wheel"
        "video"
      ];
    }
  ];

  modules = [
    ./configuration.nix
    ./filesystems.nix
    ./hardware.nix
    ./packages.nix
  ];
}
