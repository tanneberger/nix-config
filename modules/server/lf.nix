{ pkgs, ... }: {
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "tcrs24.tanneberger.me" = {
          enableACME = true;
          forceSSL = true;
          http2 = true;
          locations = {
            "/" = {
              index = "index.html";
              root = "${pkgs.lf-frontend-tcrs24}/html";
            };
            "/websocket" = {
              proxyPass = "http://127.0.0.1:8080";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };

  lf.backend = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8080 31812 ];
}
