{ pkgs, lib, ... }:
let
  alarm-clock = pkgs.callPackage ../pkgs/clock.nix {
    mkDerivation = pkgs.stdenv.mkDerivation;
  };
in
{
  systemd = {
    services."lf-alarm-clock" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.coreutils}/bin/touch /home/lf-alarm-clock/alarm_clock_events.csv
        ${pkgs.coreutils}/bin/chmod 777 /home/lf-alarm-clock/alarm_clock_events.csv
        ${pkgs.coreutils}/bin/chmod 777 /home/lf-alarm-clock
        ${pkgs.coreutils}/bin/chown lf-alarm-clock /home/lf-alarm-clock/alarm_clock_events.csv
        ${pkgs.coreutils}/bin/echo "Starting AlarmClock"
        ${alarm-clock}/bin/AlarmClock
      '';

      serviceConfig = {
        User = "lf-alarm-clock";
        Restart = "on-failure";
      };
    };
  };

  users.users.lf-alarm-clock = {
    name = "lf-alarm-clock";
    extraGroups = [ "audio" "wheel" ];
    description = "custom user for service";
    createHome = true;
    isNormalUser = true;
  };
}

