{
  programs.nh.clean = {
    enable = true;
    dates = "daily";
    extraArgs = "--keep-one --keep-since 3d";
  };
}
