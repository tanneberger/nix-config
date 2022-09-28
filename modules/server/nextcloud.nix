{ config, pkgs, ... }: {
  sops.secrets.nextcloud_db_pass.owner = "nextcloud";
  sops.secrets.nextcloud_admin_pass.owner = "nextcloud";

  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions = {
          "DATABASE nextcloud" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "nextcloud" ];
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.tassilo-tanneberger.de";
    https = true;
    package = pkgs.nextcloud24;
    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbhost = "/run/postgresql";
      dbpassFile = "${config.sops.secrets.nextcloud_db_pass.path}";
      overwriteProtocol = "https";
      adminuser = "admin";
      adminpassFile = "${config.sops.secrets.nextcloud_admin_pass.path}";
    };
  };

  services.nginx.virtualHosts."cloud.tassilo-tanneberger.de".forceSSL = true;
  services.nginx.virtualHosts."cloud.tassilo-tanneberger.de".enableACME = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
