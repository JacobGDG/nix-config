{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ./base.nix
  ];

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  myModules = {
    devops = {
      enable = true;
      terraform.enable = true;
      kubernetes.enable = true;
      aws.enable = true;
    };
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
      (
        python311.withPackages (ps: [ps.pip])
      )
    ];
  };
}
