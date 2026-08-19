{
  nixpkgs.allowedUnfreePackages = ["libsciter"];

  flake.modules.homeManager.rustdesk = {pkgs, ...}: {
    home.packages = [
      pkgs.rustdesk
    ];
  };
}
