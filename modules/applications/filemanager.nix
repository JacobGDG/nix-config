{...}: {
  jg.filemanager.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.kdePackages.dolphin];

    services.udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        };
      };
    };
  };
}
