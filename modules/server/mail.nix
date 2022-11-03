{ pkgs, lib, config, ... }: {
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
    domains = [ "tassilo-tanneberger.de" ];
    loginAccounts = {
      "me@tassilo-tanneberger.de" = {
        name = "tassilo";
        hashedPasswordFile = "${config.sops.secrets.mailserver-tassilo.path}";
        aliases = [ ];
      };
    };
  };
}
