{
  imports = [
    ../../modules/nixos/my-modules/qbittorrent.nix
    ../../modules/nixos/my-modules/vpn.nix
  ];

  myModules.nixOS.vpn.enable = true;
}
