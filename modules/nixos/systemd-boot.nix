{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "auto";

      bootCounting.enable = true;
    };

    timeout = 0;
  };
}
