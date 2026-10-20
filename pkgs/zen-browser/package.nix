{
  lib,
  wrapFirefox,
  zen-browser-unwrapped,
  stdenv,
}:
# Manually override hash until this is fixed:
# https://github.com/youwen5/zen-browser-flake/issues/24
let
  zen-browser =
    if zen-browser-unwrapped.version == "1.23.3b" then
      let
        hash =
          if stdenv.hostPlatform.system == "x86_64-linux" then
            "sha256-uyBF0+IWVNQP6EElAJLurf0sH8gx7vtQkiJ3PIvcoUk="
          else
            "sha256-EQDLPoVyVO26gzopPrUAEN5moWZGXt/NzIU23ecy36c=";
      in
      zen-browser-unwrapped.override (_: {
        inherit hash;
      })
    else
      zen-browser-unwrapped;
in
wrapFirefox zen-browser {
  pname = "zen-browser";

  extraPolicies = import ./policies.nix // {
    SearchEngines = import ./search.nix;

    ExtensionSettings = builtins.mapAttrs (_: slug: {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${slug}/latest.xpi";
      installation_mode = "normal_installed";
    }) (import ./extensions.nix);
  };

  extraPrefs = lib.generators.toKeyValue {
    mkKeyValue = name: value: "pref(${builtins.toJSON name}, ${builtins.toJSON value});";
  } (import ./preferences.nix);
}
