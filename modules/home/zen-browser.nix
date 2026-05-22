{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.zen-browser;
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = lib.mkIf cfg.enable {
    setAsDefaultBrowser = true;

    # See https://mozilla.github.io/policy-templates/
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisableMasterPasswordCreation = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      HTTPSOnlyMode = "force_enabled";
      InstallAddonsPermission.Default = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      SanitizeOnShutdown = true;

      Cookies.Allow = [
        "https://web.whatsapp.com"
        "https://youtube.com"
        "https://github.com"
      ];

      DNSOverHTTPS = {
        Enabled = false;
        Locked = true;
      };

      ExtensionSettings =
        let
          mkExtensionSettings = builtins.mapAttrs (
            _: pluginId: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
              installation_mode = "force_installed";
            }
          );
        in
        mkExtensionSettings {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "@testpilot-containers" = "multi-account-containers";
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = "styl-us";
        }
        // {
          "*".installation_mode = "blocked";
        };

      Permissions.Notifications.Allow = [
        "https://web.whatsapp.com"
      ];

      PopupBlocking = {
        Default = false;
        Locked = true;
      };

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        SuspectedFingerprinting = true;
        EmailTracking = true;
        Category = "strict";
      };
    };

    profiles.Profile0 = rec {
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

      mods = [
        "2317fd93-c3ed-4f37-b55a-304c1816819e" # Audio Indicator Enhanced
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
        "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "cb15abdb-0514-4e09-8ce5-722cf1f4a20f" # Hide Extension Name
        "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
      ];

      pins = {
        "WhatsApp" = {
          id = "38dac65f-2c38-4d6e-91c4-57426610b304";
          container = containers."Personal".id;
          url = "https://web.whatsapp.com";
          isEssential = true;
          position = 100;
        };

        "YouTube" = {
          id = "8479c4ea-26ba-40da-8e3a-430bfd12f153";
          container = containers."Personal".id;
          url = "https://youtube.com";
          isEssential = true;
          position = 101;
        };

        "qBittorrent" = {
          id = "574216d2-1d5a-4f65-9fb6-c255ef62112c";
          container = containers."Sandbox".id;
          url = "http://localhost:8080";
          isEssential = true;
          position = 102;
        };
      };

      settings = {
        "zen.mods.AudioIndicatorEnhanced.audioWave.enabled" = true;
        "theme-better_find_bar-enable_custom_background" = true;
        "theme.better_find_bar.custom_background" = "#1e1e2e";

        "browser.translations.enable" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "zen.view.compact.enable-at-startup" = true;
        "zen.view.experimental-no-window-controls" = true;
        "zen.workspaces.separate-essentials" = false;
        "zen.urlbar.replace-newtab" = true;
      };

      spaces = {
        "Default" = {
          id = "5738733a-a57e-4132-97cf-e3d8f0387cf2";
          container = containers."Sandbox".id;
          position = 1000;
        };
      };

      containersForce = true;
      pinsForce = true;
      spacesForce = true;

      search = {
        force = true;
        default = "google";
        engines = {
          NixOS = {
            name = "NixOS Search";
            definedAliases = [ "@ns" ];
            urls = [
              {
                template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
              }
            ];
          };

          Nixpkgs = {
            name = "NixOS Packages";
            definedAliases = [ "@np" ];
            urls = [
              {
                template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
              }
            ];
          };

          GitHub = {
            name = "GitHub Search";
            definedAliases = [ "@gh" ];
            urls = [
              {
                template = "https://github.com/search?q={searchTerms}";
              }
            ];
          };
        };
      };
    };
  };
}
