{ pkgs, ... }: {
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
              index = "index.html";
              root = "${pkgs.website}/html";
            };
          };
        };
        "files.tanneberger.me" = {
          enableACME = true;
          forceSSL = true;
          http2 = true;
          locations = {
            "/" = {
              root = "/var/lib/ftp/";
            };
          };
        };
      };
    };
  };
}
