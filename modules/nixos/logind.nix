{
  services.logind.settings.Login = {
    IdleAction = "sleep";
    IdleActionSec = "5m";
    HandlePowerKey = "sleep";
    HandlePowerKeyLongPress = "poweroff";
  };
}
