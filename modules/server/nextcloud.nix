{ config, pkgs, ... }: {
  sops.secrets.nextcloud_db_pass.owner = "nextcloud";
  sops.secrets.nextcloud_admin_pass.owner = "nextcloud";

  services.postgresql = {
    enable = true;
    ensureUsers = [{
        name = "nextcloud";
        ensureDBOwnership = true;
        #ensurePasswordFile = config.sops.secrets.nextcloud_db_pass.path;
    }];
    settings = {
      ssl = true;
    };
    ensureDatabases = [ "nextcloud" ];
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.tanneberger.me";
    https = true;
    package = pkgs.nextcloud27;
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

  services.nginx.virtualHosts."cloud.tanneberger.me".forceSSL = true;
  services.nginx.virtualHosts."cloud.tanneberger.me".enableACME = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
