{
  pkgs,
  config,
  mylib,
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
    # copilot-language-server-fhs
    yaml-language-server
    nil # nix
    ruff # python
  ];

  xdg.configFile."nvim/init.lua".enable = false; # avoid clash
  xdg.configFile."nvim" = {
    enable = true;
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink ( mylib.relativeToRoot "config/nvim" );
    target = "nvim";
  };
}
