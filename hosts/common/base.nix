{
  pkgs,
  mylib,
  inputs,
  ...
}: {
  imports =
    [
      inputs.nix-colors.homeManagerModules.default
      ../../modules/home-manager
    ]
    ++ map mylib.homeManagerModules [
      "scripts"
      "my-modules"
    ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  myModules = {
    git = {
      enable = true;
      global-pre-commit.enable = true;
    };
    llm.enable = true;
    kitty.enable = true;
    nvim.enable = true;
    zsh = {
      enable = true;
      starship.enable = true;
    };
    tmux = {
      enable = true;
      tmuxifier.enable = true;
      sesh = {
        enable = true;
        startup_command = "tmuxifier load-window vimsplit && tmux move-window -t 0 && tmux kill-window -t 1";
        sessions = [
          {
            name = "NixConfig 🔧";
            path = "~/src/nix-config/main/";
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
