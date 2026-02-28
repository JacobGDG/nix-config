{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common/linux-base.nix
  ];

  myModules = {
    common = {
      desktop = true;
      wallpaper = "${inputs.wallpapers}/nature/view_of_marshfield.jpg";
    };
    hyprland.hypridle = {
      auto_screenoff_timeout = 1800; # 30 minutes
      auto_suspend_timeout = 1801; # 30 minutes + 1 second
    };
  };

  home.packages = with pkgs; [
    btop-cuda
  ];
}
