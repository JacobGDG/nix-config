{
  config,
  lib,
  mylib,
  pkgs,
  ...
}: let
  cfg = config.myModules.nvim;
in {
  options = {
    myModules.nvim = {
      enable = lib.mkOption {
        default = true;
        description = ''
          whether to enable
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      defaultEditor = true;

      withNodeJs = true;
      withPython3 = true;
    };

    home.packages = with pkgs; [
      gcc

      # LSPs
      lua-language-server
      # copilot-language-server-fhs
      yaml-language-server
      nil # nix
      ruff # python
    ];

    xdg.configFile."nvim/init.lua".enable = false; # avoid clash
    xdg.configFile."nvim" = {
      enable = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink (mylib.relativeToRoot "config/nvim");
      target = "nvim";
    };
  };
}
