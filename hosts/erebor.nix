{
  pkgs,
  mylib,
  ...
}: {
  imports = [
    ./linux-base.nix
  ];

  myModules = {
    common = {
      desktop = true;
    };
  };

  home.packages = with pkgs; [
    btop-cuda
  ];
}
