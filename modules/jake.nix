{
  flake.modules.homeManager = {
    jake = {
      home = {
        username = "jake";
        homeDirectory = "/home/jake";
      };

      wayland.windowManager.hyprland.settings = {
        exec-once = ["kitty"]; #TODO: make generic
        input = {
          kb_layout = "gb";
          kb_options = "ctrl:nocaps";
        };
      };
    };
    "jake@erebor" = {};
  };
}
