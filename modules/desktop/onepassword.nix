{
  nixpkgs.allowedUnfreePackages = ["1password-cli"];

  flake.modules.homeManager.onePassword = {pkgs, ...}: {
    home.packages = [
      pkgs._1password-cli
    ];
  };
}
