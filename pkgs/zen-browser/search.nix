{
  Default = "google";
  Add = [
    {
      Name = "NixOS Options";
      URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
      IconURL = "https://brand.nixos.org/logos/nixos-logo-default-gradient-black-regular-horizontal-recommended.svg";
      Alias = "@no";
    }
    {
      Name = "NixOS Packages";
      URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
      IconURL = "https://brand.nixos.org/logos/nixos-logo-default-gradient-black-regular-horizontal-recommended.svg";
      Alias = "@np";
    }
    {
      Name = "Noogle";
      URLTemplate = "https://noogle.dev/q/?term={searchTerms}";
      IconURL = "https://brand.nixos.org/logos/nixos-logo-default-gradient-black-regular-horizontal-recommended.svg";
      Alias = "@ng";
    }
    {
      Name = "GitHub Search";
      URLTemplate = "https://github.com/search?q={searchTerms}";
      IconURL = "https://upload.wikimedia.org/wikipedia/commons/9/91/Octicons-mark-github.svg";
      Alias = "@gh";
    }
  ];
}
