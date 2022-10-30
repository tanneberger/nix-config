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
    # yarn build wants to create a .cache dir in the node_modules folder, which fails with the standard yarn2nix directory management
    # use a simplistic alternative
    configurePhase = "cp -r $node_modules node_modules && chmod +w node_modules";
    buildPhase = ''yarn build --offline'';
    installPhase = ''mv build $out'';
    distPhase = "true";
  };

in
{
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
            "*.html" = {
              root = "${frontend}/";
            };
          };
        };
      };
    };
  };
}
