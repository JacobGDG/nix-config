{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myModules.testModule;
  test-module = pkgs.writeShellScriptBin "test-module" ''
    #!/bin/bash

    echo "This is a test module for Home Manager. Hello ${cfg.testValue}"
  '';
in {
  options = {
    myModules.testModule = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable test module.
        '';
      };
      testValue = lib.mkOption {
        default = "World";
        description = ''
          A test value
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [test-module];
  };
}
