{
  persist = {
    users = {
      directories = [
        ".cache/cliphist"
      ];
    };
  };

  flake.modules.homeManager.clipboard = {pkgs, ...}: {
    home.packages = with pkgs; [
      grim
      slurp
    ];

    services.cliphist = {
      enable = true;
    };
  };
}
