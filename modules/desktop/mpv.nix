{
  flake.modules.homeManager.mpv = {pkgs, ...}: {
    programs.mpv = {
      enable = true;
      package = pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          uosc
          sponsorblock
          mpris
        ];

        # mpv = pkgs.mpv-unwrapped.override {
        #   waylandSupport = true;
        # };
      };

      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };
  };
}
