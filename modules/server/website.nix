{pkgs, config, ...}: {
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "tanneberger.me" = {
          enableACME = true;
          forceSSL = true;
          http2 = true;
          locations = {
            "/" = {
              root = "/var/lib/webiste";
            };
          };
        };
      };
    };
  };
}
