{
  pkgs,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    withNodeJs = true;
    withPython3 = true;
  };

  home.packages = with pkgs; [
    gcc
    wl-clipboard

    # LSPs
    lua-language-server
    nil # nix
    yaml-language-server
    ruff # python
  ];

  xdg.configFile."nvim/init.lua".enable = false; # avoid clash
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/nix-config/config/nvim";
}
