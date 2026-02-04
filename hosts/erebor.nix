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
  };

  home.packages = with pkgs; [
    btop-cuda
    discord
  ];
}
