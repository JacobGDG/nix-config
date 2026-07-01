{
  nixpkgs.allowedUnfreePackages = ["discord" "google-chrome"];

  flake.modules.homeManager.han = {
    pkgs,
    inputs,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      starship
      firefox
      libreoffice
    ];

    home = {
      username = "han";
      homeDirectory = "/home/han";

      packages = with pkgs; [
        just
        htop
        discord
        google-chrome
      ];
    };

    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "gb";
        kb_options = "ctrl:nocaps";
        repeat_delay = 200;
        repeat_rate = 40;
      };
      exec-once = [
        "steam"
      ];
    };
  };
}
