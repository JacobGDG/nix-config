{
  imports = [
    ../../modules/nixos/my-modules/qbittorrent.nix
    ../../modules/nixos/my-modules/homer.nix
  ];

  myModules.nixOS.qbittorrent.enable = false;
  myModules.nixOS.homer.enable = true;
}
