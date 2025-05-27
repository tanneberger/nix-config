{ ... }:
let
  cms-addr = "127.0.0.1";
  cms-port = 8090;
in
{

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

  };
  users.users.lasr = {
    isSystemUser = true;
    group = "lasr";
  };

  users.groups.lasr = { };

  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "lasr.org" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://${cms-addr}:${toString cms-port}/";
            };
          };
        };
        "www.lasr.org" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://${cms-addr}:${toString cms-port}/";
            };
          };
        };
        "lasr.tanneberger.me" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://${cms-addr}:${toString cms-port}/";
            };
          };
        };

      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
