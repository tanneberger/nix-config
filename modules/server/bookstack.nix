{ config, ... }: {

  services = {
    bookstack = {
      enable = true;
      nginx = {
        forceSSL = true;
        enableACME = true;
      };

      hostname = "bookstack.tassilo-tanneberger.de";

      database = {
        user = "bookstack";
        host = "localhost";
        port = config.services.postgresql.port;
        name = "bookstack";
        #createLocally = true;

        passwordFile = "${config.sops.secrets.postgres_password_bookstack.path}";
      };
      appKeyFile = "${config.sops.secrets.bookstack_app_key.path}";
    };
    postgresql = {
      enable = true;

      ensureDatabases = [
        "bookstack"
      ];
      ensureUsers = [
        {
          name = "bookstack";
          ensurePermissions = {
            "DATABASE bookstack" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };

  users.users.bookstack = {
    name = "bookstack";
    isNormalUser = false;
    isSystemUser = true;
    extraGroups = [ "bookstack" ];
  };

  users.groups.bookstack = { };
  sops.secrets.postgres_password_bookstack = {
    owner = config.systemd.services.bookstack-setup.serviceConfig.User;
    mode = "0440";
  };

  sops.secrets.bookstack_app_key = {
    owner = config.systemd.services.bookstack-setup.serviceConfig.User;
    mode = "0440";
  };

}
