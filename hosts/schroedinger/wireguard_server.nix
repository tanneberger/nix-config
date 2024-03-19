{ config, ... }:
let
  port = 51820;
in
{
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.firewall.allowedUDPPorts = [ port ];
  networking.wireguard.enable = true;
  systemd.network = {
    netdevs."hole" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "hole";
        Description = "tassilos's enterprise grade network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg-hole-seckey".path;
        ListenPort = port;
      };
      wireguardPeers = [
        {
          # kirchhof
          wireguardPeerConfig = {
            PublicKey = "LtAZ8Zmpdbfayg8bIfocWE0jjgHVaTxlGixWlUzW61o=";
            AllowedIPs = [ "10.66.66.10/32" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."hole" = {
      matchConfig.Name = "hole";
      networkConfig = {
        Address = "10.66.66.1/24";
        IPForward = "ipv4";
      };
    };
  };
}
