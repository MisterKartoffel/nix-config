{
  programs.vesktop = {
    settings = {
      discordBranch = "stable";
      hardwareVideoAcceleration = true;
      staticTitle = true;
      enableSplashScreen = false;
    };

    vencord.settings.plugins = {
      AnonymiseFileNames.enabled = true;
      BetterUploadButton.enabled = true;
      ClearURLs.enabled = true;
      GifPaste.enabled = true;
      MessageLinkEmbeds.enabled = true;
      NoReplyMention.enabled = true;
    };
  };
}
