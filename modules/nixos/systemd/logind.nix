{
  services.logind.settings.Login = {
    IdleAction = "sleep";
    IdleActionSec = "0s";
    HandlePowerKey = "sleep";
    HandlePowerKeyLongPress = "poweroff";
  };
}
