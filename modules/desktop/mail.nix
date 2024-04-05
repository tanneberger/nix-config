{ pkgs, config, lib, ... }:
let
  custom-mbsync-config = (pkgs.writeScriptBin "mbsync" ''
    IMAPAccount dd-ix
    AuthMechs Login
    CertificateFile /etc/ssl/certs/ca-certificates.crt
    Host imap.migadu.net
    PassCmd "cat ${config.sops.secrets.dd-ix-mail.path}"
    Port 993
    SSLType IMAPS
    User tassilo@dd-ix.net

    IMAPStore dd-ix-remote
    Account dd-ix

    MaildirStore dd-ix-local
    Inbox /home/revol-xut/Maildir/dd-ix/Inbox
    Path /home/revol-xut/Maildir/dd-ix/
    SubFolders Verbatim

    Channel dd-ix
    Create Near
    Expunge None
    Far :dd-ix-remote:
    Near :dd-ix-local:
    Patterns *
    Remove None
    SyncState *

    IMAPAccount ifsr
    AuthMechs Login
    CertificateFile /etc/ssl/certs/ca-certificates.crt
    Host mail.ifsr.de
    PassCmd "cat ${config.sops.secrets.ifsr-mail.path}"
    Port 993
    SSLType IMAPS
    User tassilo.tanneberger

    IMAPStore ifsr-remote
    Account ifsr

    MaildirStore ifsr-local
    Inbox /home/revol-xut/Maildir/ifsr/Inbox
    Path /home/revol-xut/Maildir/ifsr/
    SubFolders Verbatim

    Channel ifsr
    Create Near
    Expunge None
    Far :ifsr-remote:
    Near :ifsr-local:
    Patterns *
    Remove None
    SyncState *

    IMAPAccount tu-dresden
    AuthMechs Login
    CertificateFile /etc/ssl/certs/ca-certificates.crt
    Host msx.tu-dresden.de
    PassCmd "cat ${config.sops.secrets.tud-mail.path}"
    Port 993
    SSLType IMAPS
    User tata551d

    IMAPStore tu-dresden-remote
    Account tu-dresden

    MaildirStore tu-dresden-local
    Inbox /home/revol-xut/Maildir/tu-dresden/Inbox
    Path /home/revol-xut/Maildir/tu-dresden/
    SubFolders Verbatim

    Channel tu-dresden
    Create Near
    Expunge None
    Far :tu-dresden-remote:
    Near :tu-dresden-local:
    Patterns *
    Remove None
    SyncState *
  '');
in
{
  sops.secrets = {
    "tud-mail" = {
      owner = "revol-xut";
    };
    "ifsr-mail" = {
      owner = "revol-xut";
    };
    "c3d2-mail" = {
      owner = "revol-xut";
    };
    "dd-ix-mail" = {
      owner = "revol-xut";
    };
  };


  systemd.user = {
    services.mbsync = {
      enable = true;
      after = [ "graphical.target" ];
      script = ''
        ${pkgs.isync}/bin/mbsync -a --config=${custom-mbsync-config}/bin/mbsync
        #${pkgs.isync}/bin/mbsync -a
        #${pkgs.notmuch}/bin/notmuch new
        #${pkgs.libnotify}/bin/notify-send 'REEEEEE FUCK MAIL'
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
    timers.mbsync = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "mbsync.service";
        OnCalendar = "*-*-* *:*:00";
        Persistent = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [ imapnotify libnotify ];

  programs.msmtp = {
    enable = true;
    defaults = {
      auth = true;
      tls = true;
      logfile = "~/tmp/msmtp.log";
    };
    accounts = {
      tu-dresden = {
        auth = true;
        host = "msx.tu-dresden.de";
        port = 587;
        from = "tassilo.tanneberger@tu-dresden.de";
        user = "tata551d";
        passwordeval = "pass tu-dresden/tassilo.tanneberger@tu-dresden.de | head -1";
      };
      ifsr = {
        auth = true;
        host = "mail.ifsr.de";
        port = 587;
        from = "tassilo.tanneberger@ifsr.de";
        user = "tassilo.tanneberger";
        passwordeval = "pass dfn/tassilo.tanneberger@ifsr.de | head -1";
      };
      c3d2 = {
        auth = true;
        host = "mail.c3d2.de";
        port = 587;
        from = "revol-xut@mail.c3d2.de";
        user = "revol-xut";
        passwordeval = "pass email/revol-xut@mail.c3d2.de | head -1";
      };
      dd-ix = {
        auth = true;
        host = "smtp.migadu.com";
        port = 465;
        from = "tassilo@dd-ix.net";
        user = "tassilo@dd-ix.net";
        passwordeval = "pass email/tassilo@dd-ix.net | head -1";
      };
    };
  };
}
