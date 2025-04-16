{
  pkgs,
  lib,
  mylib,
  ...
}: {
  imports =
    [
      ./base.nix
    ]
    ++ (map mylib.homeManagerModules [
      "terraform.nix"
    ]);

  home = {
    homeDirectory = "/Users/jakegreenwood";
    username = "jakegreenwood";

    sessionPath = [
      "/opt/homebrew/bin/brew"
    ];

    packages = with pkgs; [
      docker-credential-helpers
    ];
  };
}
