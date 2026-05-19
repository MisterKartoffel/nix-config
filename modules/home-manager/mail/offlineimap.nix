{
  config,
  lib,
  ...
}:
let
  inherit (config.accounts.email.accounts) hotmail ufrgs;
in
{
  accounts.email.accounts = {
    hotmail.offlineimap.extraConfig.remote = lib.mkIf hotmail.offlineimap.enable {
      auth_mechanisms = lib.toUpper hotmail.imap.authentication;
      oauth2_client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
      oauth2_request_url = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize";
      oauth2_access_token_eval = "%(remotepasseval)s";
      createfolders = false;
    };

    ufrgs.offlineimap.extraConfig.remote = lib.mkIf ufrgs.offlineimap.enable {
      auth_mechanisms = lib.toUpper ufrgs.imap.authentication;
      createfolders = false;
    };
  };

  programs.offlineimap =
    lib.mkIf
      (
        lib.any (account: account.offlineimap.enable) (lib.attrValues config.accounts.email.accounts)
        || config.services.imapnotify.enable
      )
      {
        enable = true;

        # Needed because the default remotepasseval strips
        # on bytes and offlineimap strips on string.
        pythonFile = ''
          import subprocess

          class SafeString(str):
          	def strip(self, chars=None):
          		if isinstance(chars, (bytes, bytearray)):
          			chars = chars.decode("utf-8", errors="ignore")
          		return SafeString(super().strip(chars))

          def get_pass(service, cmd):
          	out = subprocess.check_output(cmd)
          	return SafeString(out.decode("utf-8", errors="replace").strip())
        '';
      };
}
