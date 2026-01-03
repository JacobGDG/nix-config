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
      wallpaper = "${inputs.wallpapers}/nature/haystacks.jpg";
    };
  };

  home.packages = with pkgs; [
    btop
  ];
}
