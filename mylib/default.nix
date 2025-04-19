{lib, ...}: {
  relativeToRoot = lib.path.append ../.;
  homeManagerModules = lib.path.append ../modules/home-manager;
  nixosModules = lib.path.append ../modules/nixos;
}
