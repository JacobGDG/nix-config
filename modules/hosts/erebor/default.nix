{
  hosts.erebor = {
    system = "x86_64-linux";
    configurator = "nixos";
  };

  flake.modules.nixos."nixosConfigurations/erebor" = {inputs, ...}: {
    imports = with inputs.self.modules.nixos; [
      nvidia
      hyprland
      firefox
      steam
    ];

    networking.hostName = "erebor";

    system = {
      stateVersion = "25.05";
      autoUpgrade.enable = false;
    };
  };

  flake.modules.homeManager.erebor = {
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
    ];

    home.packages = with pkgs; [
      btop-cuda
    ];
  };
}
