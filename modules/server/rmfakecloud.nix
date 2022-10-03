{ pkgs, config, lib, mkYarnPackage, ... }: 
let


  source = pkgs.stdenv.mkDerivation rec {
    name = "source-rmfakecloud";
    version = "0.0.8";
    src = pkgs.fetchFromGitHub {
      owner = "ddvk";
      repo = "rmfakecloud";
      rev = "v${version}";
      sha256 = "sha256-Q9zymQW8XWApy5ssfMtojN4AhteqrQzZyMeAkOsJDyw=";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/
      cp -r ./ui/* $out/
    '';
  };
  frontend = pkgs.mkYarnPackage rec {
    pname = "rmfakecloud-frontend";
    version = "0.0.8";
    
    src = source;

  };

in {
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
            "~.html" = {
              root = "${frontend}/";
            };
          };
        };
      };
    };
  };
}
