{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "wofi-emoji";

      runtimeInputs = with pkgs; [
        wofi
        wtype
        wl-clipboard
      ];

      text = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Zeioth/wofi-emoji/7fe4c6316cb69ff7d8cf1b98ece4695d42785e2a/wofi-emoji";
        hash = "sha256-zv3hDGSthPvajwFtb75JjorS3GCXaxeKg4SZbP57LAU=";
        executable = true;
      };
    })
  ];

  programs.wofi = {
    enable = true;
  };
}
