{
  hosts.jake-laptop-nixos = {
    system = "x86_64-linux";
    configurator = "nixos";
  };

  flake.modules.nixos."nixosConfigurations/jake-laptop-nixos" = {inputs, ...}: {
    imports = with inputs.self.modules.nixos; [
      hyprland
      firefox
      steam
      battery
    ];

    networking.hostName = "jake-laptop-nixos";

    system = {
      stateVersion = "24.05";
      autoUpgrade.enable = false;
    };
  };

  flake.modules.homeManager.jake-laptop-nixos = {
    inputs,
    pkgs,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      hyprland
      waybar
      dunst
      hypridle
      hyprlock
      hyprpaper
      wlogout
      wofi
      terminal
      battery
    ];

    home.packages = with pkgs; [
      btop
    ];
  };
}
