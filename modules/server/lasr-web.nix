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

  /*systemd.services."routinator" = {
    enable = true;
    wantedBy = [ "multi-user.target" ];

    script = ''
      ${pkgs.aspa_routinator}/bin/routinator --config ${(config-file "routinator")} --no-rir-tals --extra-tals-dir="/var/lib/routinator/tals" server --http ${http-host}:${toString http-port} --rtr ${rtr-host}:${toString rtr-port}
    '';
  };*/


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
