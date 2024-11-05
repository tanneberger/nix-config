{ config, ... }: {

  sops.secrets = {
    "wg-zw-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg-dvb-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg-hole-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg-dd-zone-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
    "wg-dd-ix-seckey" = {
      owner = config.users.users.systemd-network.name;
    };
  };

  networking = {
    hostName = "bothe";
    hostId = "5d40cf06";
    enableIPv6 = true;
    useNetworkd = false;

    wireguard.enable = true;

    networkmanager = {
      wifi.scanRandMacAddress = false;
      enable = true;
    };
  };
}
