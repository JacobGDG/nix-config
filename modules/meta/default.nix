{
  inputs,
  lib,
  ...
}: let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
in {
  den.default = {
    nixos = {
      system.stateVersion = "25.11";
      time.timeZone = "Europe/London";
      i18n.defaultLocale = "en_GB.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };
      console.keyMap = "uk";
      nix = {
        settings = {
          experimental-features = "nix-command flakes";
          flake-registry = "";
          nix-path = nixPath;
        };
        channel.enable = false;
        registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
        nixPath = nixPath;
      };
    };
    homeManager = {
      home.stateVersion = "25.11";
      news.display = "silent";
      programs.home-manager.enable = true;
    };
  };
}
