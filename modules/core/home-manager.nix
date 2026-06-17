{config, ...}: {
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager/release-${config.nixpkgsStableVersion}";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.core = {lib, ...}: {
    home.stateVersion = lib.mkDefault "25.05";
    news.display = "silent";
    programs.home-manager.enable = true;
    programs.zsh.enable = true;
  };
}
