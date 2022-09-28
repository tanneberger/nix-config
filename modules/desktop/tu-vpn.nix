{ config, secrets, ... }: {
  sops.secrets = {
    "openconnect-tud" = {
      owner = "root";
    };
  };

  networking.openconnect.interfaces = {
    tud = {
      user = "tata551d@tu-dresden.de";
      protocol = "anyconnect";
      gateway = "vpn2.zih.tu-dresden.de";
      passwordFile = config.sops.secrets."openconnect-tud".path;
      extraOptions = {
        authgroup = "B-Tunnel-Public-TU-Networks";
        compression = "stateless";
        no-dtls = true;
        no-http-keepalive = true;
        pfs = true;
      };
      autoStart = false;
    };
    ccc = {
      user = "tata551d@vpn-cfaed-cpb-ma";
      protocol = "anyconnect";
      gateway = "vpn2.zih.tu-dresden.de";
      passwordFile = config.sops.secrets."openconnect-tud".path;
      extraOptions = {
        authgroup = "A-Tunnel-TU-Networks";
        compression = "stateless";
        no-dtls = true;
        no-http-keepalive = true;
        pfs = true;
      };
      autoStart = false;
    };
  };
}
