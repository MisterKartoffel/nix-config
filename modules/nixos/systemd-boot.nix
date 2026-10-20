{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
      consoleMode = "auto";

      bootCounting.enable = true;
    };

    timeout = 0;
  };
}
