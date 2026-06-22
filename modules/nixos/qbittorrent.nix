{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.services) qbittorrent;
in
{
  services.qbittorrent = lib.mkIf qbittorrent.enable rec {
    openFirewall = true;
    torrentingPort = 6881;

    # I don't know why the NixOS module does all this
    # song and dance with a nested qBittorrent/qBittorrent
    # but I for sure didn't like it
    profileDir = "/var/lib";

    serverConfig = {
      Network.PortForwardingEnabled = false;
      LegalNotice.Accepted = true;

      BitTorrent = {
        MergeTrackersEnabled = true;

        Session = {
          AdditionalTrackersURL = "https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt";
          ReannounceWhenAddressChanged = true;
          AnnounceToAllTrackers = true;
          BandwidthSchedulerEnabled = true;
          AlternativeGlobalDLSpeedLimit = 3000;
          AlternativeGlobalUPSpeedLimit = 3000;
          MaxActiveCheckingTorrents = 10;
          DefaultSavePath = "${profileDir}/qBittorrent/Torrents/Complete";
          TempPath = "${profileDir}/qBittorrent/Torrents/Incomplete";
          FinishedTorrentExportDirectory = "${profileDir}/qBittorrent/.torrents/Complete";
          TorrentExportDirectory = "${profileDir}/qBittorrent/.torrents/Incomplete";
          TempPathEnabled = true;
          LSDEnabled = false;
          BTProtocol = "TCP";
          Encryption = 1;
          Preallocation = true;
        };
      };

      Preferences = {
        Scheduler = {
          end_time = "@Variant(\0\0\0\xf\x4\xefm\x80)";
          start_time = "@Variant(\0\0\0\xf\x1\x80\x85\x80)";
        };

        WebUI = {
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
          AuthSubnetWhitelistEnabled = true;
          AuthSubnetWhitelist = "192.168.0.0/24";
          LocalHostAuth = false;
        };
      };
    };
  };
}
