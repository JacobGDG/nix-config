{
  nixpkgs.allowedUnfreePackages = ["discord" "google-chrome"];

  flake.modules.homeManager.han = {
    pkgs,
    inputs,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      firefox
      libreoffice
      starship
    ];

    home = {
      username = "han";
      homeDirectory = "/home/han";

      packages = with pkgs; [
        discord
        google-chrome
        htop
        just
      ];
    };

    wayland.windowManager.hyprland = {
      extraConfig = ''
        hl.on("hyprland.start", function()
            hl.exec_cmd("steam")
        end)
      '';
    };
  };
}
