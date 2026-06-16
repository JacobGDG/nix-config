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
