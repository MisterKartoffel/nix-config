{
  config,
  pkgs,
  ...
}: let
  inherit (config.secrets.email.hotmail) email;
in {
  home.packages = with pkgs; [oama];

  accounts.email.accounts.${email}.offlineimap = {
    enable = true;

    extraConfig = {
      local = {
        nametrans = "lambda f: { \"Archive\": \"Arquivo Morto\" }.get(f, f)";
        createfolders = true;
      };

      remote = {
        folderfilter = "lambda f: f in [\"Inbox\", \"Sent\", \"Drafts\", \"Arquivo Morto\", \"Junk\", \"Deleted\"]";
        nametrans = "lambda f: { \"Arquivo Morto\": \"Archive\" }.get(f, f)";
        auth_mechanisms = "XOAUTH2";
        oauth2_request_url = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
        oauth2_access_token_eval = "get_oama_token(\"${email}\")";
      };
    };
  };

  programs.offlineimap = {
    enable = true;

    pythonFile = ''
      import subprocess

      def get_oama_token(email_address):
      	token = subprocess.run(
      		["${pkgs.oama}/bin/oama", "access", email_address],
      		capture_output=True,
      		text=True
      	).stdout.strip()
      	return token
    '';
  };
}
