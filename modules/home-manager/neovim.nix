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
    nil # nix LSP
    yaml-language-server
  ];

  xdg.configFile."nvim/init.lua".enable = false; # avoid clash
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/nix-config/config/nvim";
}
