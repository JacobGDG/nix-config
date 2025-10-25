{pkgs, ...}: {
  imports = [
    ./common/darwin-base.nix
  ];

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
