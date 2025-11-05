{pkgs, ...}: {
  home.packages = [pkgs.wireguard-tools];

  programs.zsh.shellAliases = {
    "wg-home-up" = "wg-quick up /run/agenix/home_wg_config.conf";
    "wg-home-down" = "wg-quick down /run/agenix/home_wg_config.conf";
  };
}
