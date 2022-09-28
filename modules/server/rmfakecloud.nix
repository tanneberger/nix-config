{ pkgs, config, lib, ... }: {

  services = {
    rmfakecloud = {
      enable = true;
      storageUrl = "rmfake.tassilo-tanneberger.de";
    };
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "rmfake.tassilo-tanneberger.de" = {
          enableACME = true;
          forceSSL = true;
          http2 = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.rmfakecloud.port}/";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
