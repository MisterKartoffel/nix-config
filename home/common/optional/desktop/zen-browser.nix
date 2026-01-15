{ inputs, pkgs, ... }: {
	imports = [ inputs.zen-browser.homeModules.beta ];

	programs.zen-browser = {
		enable = true;

		policies = {
			AutofillAddressEnabled = false;
			AutofillCreditCardEnabled = false;
			DisableAppUpdate = true;
			DisableFeedbackCommands = true;
			DisableFirefoxStudies = true;
			DisablePocket = true;
			DisableTelemetry = true;
			DontCheckDefaultBrowser = true;
			NoDefaultBookmarks = true;
			OfferToSaveLogins = false;
			EnableTrackingProtection = {
				Value = true;
				Locked = true;
				Cryptomining = true;
				Fingerprinting = true;
			};
		};

		profiles.Profile0 = {
			search = {
				force = true;
				default = "google";
				engines.mynixos = {
					name = "My NixOS";
					definedAliases = ["@nx"];
					urls = [
						{
							template = "https://mynixos.com/search?q={searchTerms}";
							params = [
								{
									name = "query";
									value = "searchTerms";
								}
							];
						}
					];
				};
			};

			extensions.packages =
				with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
					ublock-origin
					bitwarden
				];
		};
	};
}
