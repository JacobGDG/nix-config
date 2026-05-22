{
  nixosHosts.erebor = {
    system = "x86_64-linux";
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
      firefox
      aiAgents
      devops
      spotifyPlayer
      cava
      mpv
    ];

    home.packages = with pkgs; [
      btop-cuda
      wl-clipboard
      sshfs
      nerd-fonts.jetbrains-mono
      bc
      unzip
      ruby
    ];
  };
}
