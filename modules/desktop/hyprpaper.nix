{
  flake.modules.homeManager.hyprpaper = {
    config,
    pkgs,
    lib,
    ...
  }: {
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "${./wallpapers/haystacks.jpg}";
          }
        ];
      };
    };
  };
}
