{ pkgs, lib, config, ... }: {
  sops.secrets.gitea_db_pass.owner = config.systemd.services.gitea.serviceConfig.User;
  services = {
    gitea = {
      enable = true;
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
      settings = {
        server = {
          DOMAIN = "git.tanneberger.me";
          HTTP_PORT = 8082;
          ROOT_URL = "https://git.tanneberger.me";
        };
      };
    };
    postgresql = {
      enable = true;
    };
    nginx = {
      enable = true;
      virtualHosts."git.tassilo-tanneberger.de" = {
        forceSSL = true;
        enableACME = true;
        http2 = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.gitea.settings.server.HTTP_PORT}/";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
