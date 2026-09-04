#
{
  lib,
  wrapFirefox,
  zen-browser-unwrapped,
}:
wrapFirefox zen-browser-unwrapped {
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
