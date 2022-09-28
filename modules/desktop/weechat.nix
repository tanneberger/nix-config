{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (self: super: {
      weechat = super.weechat.override {
        configure = { availablePlugins, ... }: {
          scripts = with super.weechatScripts; [
            weechat-matrix
            wee-slack
            multiline
            colorize_nicks
          ];
        };
      };
    })
  ];
}
