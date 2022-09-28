{ pkgs, ... }: {
  hardware.bluetooth.enable = true;
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd -dn --plugin=a2dp"
  ];
  services.blueman.enable = true;
}
