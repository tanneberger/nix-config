{ config, ... }: {
  #sops.secrets = {
  #  "wg-hole-seckey" = {
  #    owner = config.users.users.systemd-network.name;
  #  };
  #};

  networking = {
    hostName = "einstein";
    hostId = "bf36ca23";

    useDHCP = true;
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    enableIPv6 = true;
    useNetworkd = true;

    wireguard.enable = true;
    firewall.enable = true;
  };

  users.users.root.initialPassword = "bruhmomentuno";

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
    networks."10-ether" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };
    };
  };
}
