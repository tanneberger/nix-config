{ pkgs, config, lib, ... }: {
  sops.secrets = {
    "wg-hole-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
  };

  networking = {
    hostName = "schroedinger";
    hostId = "163dc682";
    enableIPv6 = true;
    useDHCP = true;
    interfaces.enp1s0.useDHCP = true;
    useNetworkd = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [ "1.1.1.1" ];
  };

  # workaround for networkd waiting for shit
  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
    "" # clear old command
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  systemd.network = {
    enable = true;
    # Interfaces on the machine
    networks."10-ether-bond" = {
      matchConfig.Name = "enp1s0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
        #Mode = "active-backup";
        #PrimaryReselectPolicy = "always";
        #MIIMonitorSec = "1s";
      };
      addresses = [
        {
          addressConfig = {
            Address = "88.198.121.105/32";
          };
        }
        {
          addressConfig = {
            Address = "2a01:4f8:c012:f7d1::/64";
          };
        }
      ];
    };
  };
}
