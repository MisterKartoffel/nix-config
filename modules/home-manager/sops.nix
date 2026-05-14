{
  osConfig,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config.home) username homeDirectory;
  inherit (lib) mkIf;

  nestAttrset =
    secrets:
    lib.foldlAttrs (
      acc: path: value:
      lib.recursiveUpdate acc (lib.attrsets.setAttrByPath (lib.splitString "/" path) value)
    ) { } secrets;

  inherit (osConfig.modules.services) sops;
  inherit (config.programs) ssh;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  config = mkIf sops.enable {
    sops = {
      age = {
        sshKeyPaths = lib.mkIf ssh.enable [ "${homeDirectory}/.ssh/id_ed25519" ];
        keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
        generateKey = true;
      };

      defaultSopsFile = "${inputs.nix-secrets}/sops/home/${username}.yaml";
      validateSopsFiles = false;

      secrets = {
        "${username}/ssh_key" = lib.mkIf ssh.enable {
          path = "${homeDirectory}/.ssh/id_ed25519";
          key = "ssh_key";
        };
        "hotmail/client_id" = { };
        "hotmail/refresh_token" = { };
      };
    };

    modules.secrets = lib.foldl' lib.recursiveUpdate { } [
      (nestAttrset (config.sops.secrets or { }))
      (inputs.nix-secrets.home.${username} or { })
    ];
  };

  options.modules.secrets = lib.mkOption {
    description = "Attribute set of inputs.nix-secrets.home.${username} and sops-nix secrets";
    type = lib.types.attrs;
    default = { };
  };
}
