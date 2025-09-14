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
    tmux = {
      enable = true;
      sesh = {
        startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
        sessions = [
          {
            name = "NixConfig 🔧";
            path = "~/src/nix-config/";
            startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
          }
          {
            name = "Tomato 🍅";
            path = "~";
            startup_command = "tomato";
          }
        ];
      };
    };
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
