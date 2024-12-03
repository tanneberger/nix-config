{ ... }: {
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  hardware.pulseaudio = {
    enable = false;
    #zeroconf.discovery.enable = true;
    extraClientConf = ''
      autospawn=yes
    '';
  };

  security.rtkit.enable = true; # so pipewire / pulseaudio can get higher priority

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    audio.enable = true;
  };
}
