{
  pkgs,
  mylib,
  inputs,
  ...
}: {
  imports =
    [
      inputs.stylix.homeModules.stylix
      ../modules/home-manager/my-modules
    ]
    ++ map mylib.homeManagerModules [
      "base"
      "scripts"
    ];

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  myModules = {
    llm.enable = true;
  };

  news.display = "silent";

  # https://nix-community.github.io/stylix/
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = "${inputs.wallpapers}/nature/haystacks.jpg";
    targets = {
      firefox.profileNames = ["default"];
    };
  };

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    packages = with pkgs; [
      ripsecrets
      ttyper
      jq
      yq
    ];
  };
}
