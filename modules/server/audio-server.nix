{ pkgs, lib, config, ... }:
{
  # Enable sound.
  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    systemWide = true;
    tcp.enable = true;
    tcp.anonymousClients.allowedIpRanges = [
      "127.0.0.0/8"
      "::1/128"
      "172.22.99.0/24"
      "172.20.72.0/21"
      "192.168.1.0/24"
    ];
    zeroconf.publish.enable = true;
    package = pkgs.pulseaudioFull;
    #extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  /* services.pipewire = {
    enable = true;
    alsa.enable = true;
    config.pipewire-pulse = lib.importJSON ./pipewire-pulse.conf.json;
    pulse.enable = true;
    }; */

  security.rtkit.enable = true;

  # tell Avahi to publish CUPS and PulseAudio
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 4713 ];
}
