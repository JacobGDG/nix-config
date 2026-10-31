{
  # clipboard history lives in elephant's clipboard provider, see walker.nix
  flake.modules.homeManager.clipboard = {pkgs, ...}: {
    home.packages = with pkgs; [
      grim
      slurp
    ];
  };
}
