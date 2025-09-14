{
  imports = [
    ../../modules/nixos/my-modules/qbittorrent.nix
  ];

  myModules.nixOS.qbittorrent.enable = false;
}
