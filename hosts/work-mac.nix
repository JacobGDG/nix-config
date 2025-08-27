{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ./base.nix
  ];

  myModules = {
    devops.enable = true;
  };

  home = {
    homeDirectory = "/Users/jakegreenwood";
    username = "jakegreenwood";

    sessionPath = [
      "/opt/homebrew/bin/brew"
    ];

    packages = with pkgs; [
      btop
      docker-credential-helpers
      dbeaver-bin
    ];
  };
}
