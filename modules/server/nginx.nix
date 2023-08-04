{ pkgs, config, lib, ... }: {
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "revol-xut@protonmail.com";
  #security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

  services = {
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "tanneberger.me" = {
            enableACME = true;
            forceSSL = true;
            http2 = true;
            globalRedirect = "https://github.com/revol-xut";
          };
        };
      };
    };
}
