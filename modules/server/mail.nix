{pkgs, lib, config, ...}: {
    mailserver = {
       enable = true;
       fqdn = "mail.tassilo-tanneberger.de";
       domains = [ "tassilo-tanneberger.de" ];
       loginAccounts = {
           "me@tassilo-tanneberger.de" = {
               # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2 > /hashed/password/file/location
               #hashedPasswordFile = "/hashed/password/file/location";

               aliases = [];
           };
       };
     };
}
