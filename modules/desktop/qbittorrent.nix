{
  persist = {
    users = {
      directories = [
        ".config/qBittorrent"
        "Downloads/p2p"
      ];
    };
  };

  flake.modules.homeManager.qbittorrent = {pkgs, ...}: {
    home.packages = [
      pkgs.qbittorrent
    ];
  };
}
