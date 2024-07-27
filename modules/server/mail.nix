{ config, ... }: {
  sops.secrets = {
    "mailserver-tassilo".owner = config.users.users.postfix.name;
  };
  mailserver = {
    enable = true;
    enableImap = true;
    enableImapSsl = true;
    enableManageSieve = true;
    enableSubmission = true;

    fqdn = "mail.tassilo-tanneberger.de";

    # Certificate setup
    certificateScheme = 1;
    certificateFile = "/var/lib/acme/${cfg.domain}/fullchain.pem";
    keyFile = "/var/lib/acme/${cfg.domain}/key.pem";

    domains = [ "tassilo-tanneberger.de" ];
    loginAccounts = {
      "me@tassilo-tanneberger.de" = {
        name = "tassilo";
        hashedPasswordFile = "${config.sops.secrets.mailserver-tassilo.path}";
        aliases = [ ];
      };
    };
  };

  services.roundcube = {
    enable = true;
    # this is the url of the vhost, not necessarily the same as the fqdn of
    # the mailserver
    hostName = "webmail.tassilo-tanneberger.de";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  services.nginx.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
