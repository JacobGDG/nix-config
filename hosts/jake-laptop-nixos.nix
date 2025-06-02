{
  pkgs,
  mylib,
  ...
}: {
  imports = [
    ./linux-base.nix
  ];
  home.packages = with pkgs; [
    btop
  ];
}
