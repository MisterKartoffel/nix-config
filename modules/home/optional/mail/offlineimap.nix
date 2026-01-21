{ config, pkgs, ... }:
let
  inherit (config.secrets) email;
in
{
  home.packages = with pkgs; [ oama ];
  programs.offlineimap = {
		enable = true;
	
		extraConfig.general = {
			accounts = "Hotmail";	
		};
	};

	xdg.configFile."offlineimap/config".text = ''
[Account Hotmail]
localrepository = Hotmail-local
remoterepository = Hotmail-remote

[Repository Hotmail-local]
type = Maildir
localfolders = ${config.home.homeDirectory}/Mail/Hotmail
nametrans = lambda f: { "Archive": "Arquivo Morto" }.get(f, f)
createfolders = True

[Repository Hotmail-remote]
type = IMAP
remotehost = outlook.office365.com
remoteuser = ${email.hotmail.email}
folderfilter = lambda f: f in ["Inbox", "Sent", "Drafts", "Arquivo Morto", "Junk", "Deleted"]
nametrans = lambda f: { "Arquivo Morto": "Archive" }.get(f, f)
auth_mechanisms = XOAUTH2
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
oauth2_request_url = https://login.microsoftonline.com/common/oauth2/v2.0/token
oauth2_client_id = ${email.hotmail.client_id}
oauth2_client_secret =
oauth2_refresh_token = ${email.hotmail.refresh_token}
		'';
}
