{
  osConfig,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.home) username homeDirectory;
  inherit (osConfig.modules.services) sops;
  inherit (config.programs) ssh;

  nestAttrset =
    secrets:
    lib.foldlAttrs (
      acc: path: value:
      lib.recursiveUpdate acc (lib.attrsets.setAttrByPath (lib.splitString "/" path) value)
    ) { } secrets;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  config = lib.mkIf sops.enable {
    sops = {
      age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
      validateSopsFiles = true;

      secrets = {
        "${username}/ssh_key" = lib.mkIf ssh.enable {
          path = "${homeDirectory}/.ssh/id_ed25519";
          key = "ssh_key";
        };
        "ufrgs/password" = { };
      };
    };

    modules.secrets = nestAttrset (config.sops.secrets or { });
  };

  options.modules.secrets = lib.mkOption {
    description = "Attribute set of sops-nix secrets";
    type = lib.types.attrs;
    default = { };
  };
}
