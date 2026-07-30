{
  inputs,
  lib,
  stdenv,
  wrapFirefox,
}:
let
  inherit (inputs.zen-browser.packages.${stdenv.hostPlatform.system}) zen-browser-unwrapped;

  extraPolicies = import ./policies.nix // {
    SearchEngines = import ./search.nix;

    ExtensionSettings = builtins.mapAttrs (_: slug: {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${slug}/latest.xpi";
      installation_mode = "normal_installed";
    }) (import ./extensions.nix);
  };

  extraPrefs = lib.generators.toKeyValue {
    mkKeyValue = name: value: "lockPref(${builtins.toJSON name}, ${builtins.toJSON value});";
  } (import ./preferences.nix);
in
wrapFirefox zen-browser-unwrapped {
  pname = "zen-browser";
  inherit extraPolicies extraPrefs;
}
