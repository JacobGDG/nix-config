{
  pkgs,
  mylib,
  inputs,
  ...
}: {
  imports =
    [
      ./common/linux-base.nix
    ]
    ++ (map mylib.homeManagerModules [
      "my-modules/"
    ]);

  myModules = {
    common = {
      wallpaper = "${inputs.wallpapers}/nature/haystacks.jpg";
    };
  };

  home.packages = with pkgs; [
    btop
  ];
}
