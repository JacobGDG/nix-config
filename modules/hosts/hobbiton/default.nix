{
  hosts.hobbiton = {
    system = "x86_64-linux";
    configurator = "nixos";
    hasBattery = true;
  };

  flake.modules.nixos."nixosConfigurations/hobbiton" = {inputs, ...}: {
    imports = with inputs.self.modules.nixos; [
      battery
      firefox
      hyprland
      onePassword
      steam
    ];

    networking.hostName = "hobbiton";

    system = {
      stateVersion = "24.05";
      autoUpgrade.enable = false;
    };
  };

  flake.modules.homeManager.hobbiton = {
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
      clipboard
      battery
    ];

    home = {
      stateVersion = "24.05";
      packages = with pkgs; [
        btop
      ];
    };
  };
}
