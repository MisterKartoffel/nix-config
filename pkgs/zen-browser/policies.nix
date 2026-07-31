rec {
  /*
    Firefox Policy Reference:
    https://firefox-admin-docs.mozilla.org/reference/policies/

    Policies in this file are ordered as per
    the administration reference ordering.
  */

  # Browser UI
  DisableSetDesktopBackground = true;

  # Content settings
  Permissions.Notifications.Allow = [
    "https://web.whatsapp.com"
  ];

  PopupBlocking = {
    Default = false;
    Locked = true;
  };

  # Device update settings
  DisableAppUpdate = true;

  # Extensions
  InstallAddonsPermission.Default = false;

  # Local data storage
  DisableFormHistory = true;
  SanitizeOnShutdown = {
    Cache = true;
    Cookies = true;
    FormData = true;
    History = true;
    Sessions = true;
    SiteSettings = true;
    Exceptions = Cookies.Allow;
  };

  # Miscellaneous
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableTelemetry = true;

  # Network security
  Cookies.Allow = [
    "https://web.whatsapp.com"
    "https://youtube.com"
    "https://github.com"
  ];

  DNSOverHTTPS.Enabled = false; # Uses system DNS

  EnableTrackingProtection = {
    Value = true;
    Cryptomining = true;
    Fingerprinting = true;
    EmailTracking = true;
    SuspectedFingerprinting = true;
  };

  HTTPSOnlyMode = "enabled";
  PostQuantumKeyAgreementEnabled = true;

  # Password manager
  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  DisableMasterPasswordCreation = true;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;

  # Startup
  DontCheckDefaultBrowser = true;
}
