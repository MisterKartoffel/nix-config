{ inputs, pkgs, ... }: {
	imports = [ inputs.zen-browser.homeModules.beta ];

	programs.zen-browser = {
		enable = true;

		# See https://mozilla.github.io/policy-templates/
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
			SanitizeOnShutdown = true;

			Cookies.Allow = [
				"https://web.whatsapp.com"
				"https://youtube.com"
				"https://github.com"
			];

			Permissions.Notifications.Allow = [
				"https://web.whatsapp.com"
			];

			EnableTrackingProtection = {
				Value = true;
				Locked = true;
				Cryptomining = true;
				Fingerprinting = true;
			};
		};

		profiles.Profile0 = let
			containers = {
				Personal = {
					color = "blue";
					icon = "fingerprint";
					id = 1;
				};

				Banking = {
					color = "green";
					icon = "dollar";
					id = 2;
				};

				Shopping = {
					color = "pink";
					icon = "cart";
					id = 3;
				};

				Sandbox = {
					color = "orange";
					icon = "fence";
					id = 4;
				};
			};

			spaces = {
				"Default" = {
					id = "5738733a-a57e-4132-97cf-e3d8f0387cf2";
					container = containers."Sandbox".id;
					position = 1000;
				};
			};

			# Pins aren't currently being set up
			# See https://github.com/0xc000022070/zen-browser-flake/issues/201
			pins = {
				"WhatsApp" = {
					id = "38dac65f-2c38-4d6e-91c4-57426610b304";
					container = containers."Personal".id;
					url = "https://web.whatsapp.com";
					isEssential = false;
					position = 100;
				};

				"YouTube" = {
					id = "8479c4ea-26ba-40da-8e3a-430bfd12f153";
					container = containers."Personal".id;
					url = "https://youtube.com";
					isEssential = false;
					position = 200;
				};

				"qBittorrent" = {
					id = "574216d2-1d5a-4f65-9fb6-c255ef62112c";
					container = containers."Sandbox".id;
					url = "http://localhost:8080";
					isEssential = false;
					position = 300;
				};
			};
		in {
			pinsForce = true;
			containersForce = true;
			spacesForce = true;
			inherit containers pins spaces;

			extensions.packages =
				with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
					ublock-origin
					bitwarden
					multi-account-containers
				];

			settings = {
				zen.view.experimental-no-window-controls = true;
				toolkit.tabbox.switchByScrolling = true;
			};

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
								{ name = "query"; value = "searchTerms"; }
							];
						}
					];
				};
			};
		};
	};
}
