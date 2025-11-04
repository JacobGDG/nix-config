{
  imports = [
    ../../modules/nixos/my-modules/qbittorrent.nix
    ../../modules/nixos/my-modules/homer.nix
    ../../modules/nixos/my-modules/tlp.nix
  ];

  myModules.nixOS = {
    qbittorrent.enable = false;
    homer.enable = true;
    tlp.enable = true;
  };
}
