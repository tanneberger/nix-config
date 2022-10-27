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
        Description = "tassilos's enterprise network";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg-hole-seckey".path;
      };
      wireguardPeers = [
        {
          # kirchhof
          wireguardPeerConfig = {
            PublicKey = "WR3vczOpFNXm7LvQ+TBtajLsL+gKdwuiTUYUf8xm1Hg=";
            AllowedIPs = [ "10.1.1.2/24" ];
            Endpoint = [ "88.198.121.105:51820" ];
            PersistentKeepalive = 25;
          };
        }
      ];
    };
    networks."hole" = {
      matchConfig.Name = "hole";
      networkConfig = {
        Address = "10.1.1.1/24";
      };
      /*wireguardPeers = [
        {
          wireguardPeerConfig = {
            PublicKey = "";
            AllowedIPs = [ "${x.config.deployment-dvb.net.wg.addr4}/32" ];
            PersistentKeepalive = keepalive;
          };
        }
      ];*/
    };
  };
}
