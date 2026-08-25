{ config, ... }:
{
  services.timesyncd = {
    servers = config.networking.timeServers;

    # If the system boots up without internet access,
    # it fails to sync on boot and subsequent DNS queries
    # fail due to invalid system time. Having these
    # hardcoded Anycast IP addresses as fallback should
    # mitigate this issue.
    fallbackServers = [
      "9.9.9.9" # Quad9
      "162.159.200.1" # Cloudflare
      "216.239.35.0" # Google
    ];
  };
}
