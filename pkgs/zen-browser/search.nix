{
  Default = "google";
  Add = [
    {
      Name = "Google Maps";
      URLTemplate = "https://www.google.com/maps/search/{searchTerms}";
      IconURL = "https://www.google.com/images/branding/product/ico/maps_32dp.ico";
      Alias = "@gm";
    }
    {
      Name = "NixOS Options";
      URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
      IconURL = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
      Alias = "@no";
    }
    {
      Name = "NixOS Packages";
      URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
      IconURL = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
      Alias = "@np";
    }
    {
      Name = "Noogle";
      URLTemplate = "https://www.noogle.dev/q/?term={searchTerms}";
      IconURL = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
      Alias = "@ng";
    }
    {
      Name = "GitHub Search";
      URLTemplate = "https://www.github.com/search?q={searchTerms}";
      IconURL = "https://github.githubassets.com/favicons/favicon.svg";
      Alias = "@gh";
    }
  ];
}
