{ ... }:
let
  home = "/home/revol-xut";
in
{
  services.mpd = {
    enable = true;
    user = "revol-xut";
    playlistDirectory = "${home}/music/playlists";
    musicDirectory = "${home}/music/";
    extraConfig = ''
      audio_output {
        type            "pulse"
        name            "pulse audio"
      }

      audio_output {
          type            "alsa"
          name            "My ALSA Device"
          device            "front"    # optional
          format            "44100:16:2"    # optional
      }

      audio_output {
          type                    "fifo"
          name                    "my_fifo"
          path                    "/tmp/mpd.fifo"
          format                  "44100:16:2"
      }
    '';
  };
}

