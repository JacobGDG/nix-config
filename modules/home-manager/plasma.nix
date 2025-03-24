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
      repeatRate = 40.0;
      repeatDelay = 200;
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

    panels = [
      {
        location = "bottom";
        height = 30;
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          {
            pager = {
              general = {
                showWindowOutlines = true;
                showApplicationIconsOnWindowOutlines = true;
                showOnlyCurrentScreen = true;
                navigationWrapsAround = true;
                displayedText = "desktopNumber";
                selectingCurrentVirtualDesktop = "doNothing";
              };
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:firefox.desktop"
                "applications:systemsettings.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:Alacritty.desktop"
                "applications:steam.desktop"
              ];
              behavior = {
                showTasks = {
                  onlyInCurrentScreen = true;
                  onlyInCurrentDesktop = true;
                  onlyInCurrentActivity = true;
                };
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
              ];
              configs = {
                battery.showPercentage = true;
              };
            };
          }
          {
            digitalClock = {
              time = {
                showSeconds = "never";
                format = "24h";
              };
              calendar = {
                firstDayOfWeek = "monday";
                showWeekNumbers = true;
                plugins = [ "holidaysevents" "astronomicalevents" ];
              };
            };
          }
          "org.kde.plasma.showdesktop"
        ];
        hiding = "none";
        floating = false;
      }
    ];
  };
}
