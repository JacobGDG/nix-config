# https://github.com/nix-community/plasma-manager?tab=readme-ov-file#manage-kde-plasma-with-home-manager
{
  programs.plasma = {
    enable = true;
    overrideConfig = true; # Override manual changes

    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 20;
      };
      # iconTheme = "Breeze_Dark"; TODO: Fix this referench
      wallpaper = ../../wallpapers/haystacks.jpg;
    };

    input.keyboard = {
      layouts = [
        # search setxkbmap options
        {layout = "gb";}
      ];
      options = [
        "caps:ctrl_modifier"
      ];
    };

    fonts = {
      general = {
        family = "JetBrains Mono";
        pointSize = 9;
      };
    };

    hotkeys.commands."launch-alacritty" = {
      name = "Launch Alacritty";
      key = "Meta+K"; # run some Kommands
      command = "alacritty";
    };
  };
}
