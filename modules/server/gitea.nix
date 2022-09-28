{ pkgs, lib, config, ... }: {
  sops.secrets.gitea_db_pass.owner = config.systemd.services.gitea.serviceConfig.User;
  services = {
    gitea = {
      enable = true;
      domain = "gitea.tassilo-tanneberger.de";
      database = {
        user = "gitea";
        type = "postgres";
        port = 5432;
        name = "gitea";
        passwordFile = config.sops.secrets.gitea_db_pass.path;
        createDatabase = true;
      };
      settings = {
        service = {
          DISABLE_REGISTRATION = true;
        };
      };
      httpPort = 8081;
    };
    postgresql = {
      enable = true;
    };
    nginx = {
      enable = true;
      virtualHosts."gitea.tassilo-tanneberger.de" = {
        forceSSL = true;
        enableACME = true;
        http2 = true;
        locations = {
          "/" = {
            proxyPass = "https://127.0.0.1:${toString config.services.gitea.httpPort}/";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
