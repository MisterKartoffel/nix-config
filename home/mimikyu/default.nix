{ lib, ... }:
{
  imports = map lib.custom.relativeToRoot (
    [
      "modules/home/core"
    ]
    ++ (map (file: "modules/home/optional/${file}") [
      "desktop"
      "neovim"
      "theming"
      "environment"
    ])
  );
}
