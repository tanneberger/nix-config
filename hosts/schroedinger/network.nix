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

    wireguard.enable = true;
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

    # wait-online.ignoredInterfaces = [ "wlan0" "enp53s0" ];

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
    };
  };
}
