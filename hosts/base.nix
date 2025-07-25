{
  pkgs,
  mylib,
  inputs,
  ...
}: {
  imports =
    [
      inputs.nix-colors.homeManagerModules.default
      ../modules/home-manager/my-modules
    ]
    ++ map mylib.homeManagerModules [
      "base"
      "scripts"
    ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  myModules = {
    llm.enable = true;
  };

  news.display = "silent";

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
