{pkgs, config, ...}: {
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "poettering.tanneberger.me" = {
          enableACME = true;
          forceSSL = true;
          http2 = true;
          locations = {
            "/" = {
              root = pkgs.poettering;
            };
          };
        };
      };
    };
  };
}
