{
  flake-file.inputs.impermanance = {
    url = "github:nix-community/impermanence";
    inputs.nixpkgs.follows = "";
    inputs.home-manager.follows = "";
  };

  flake.modules.nixos.impermanance = {inputs, ...}: {
    imports = [inputs.impermanance.nixosModules.impermanence];

    fileSystems."/persist".neededForBoot = true;

    # Files must be manually copied to avoid clashes
    # 1. Copy/touch to /persist/path/to/file
    # 2. Remove from root
    # 3. Rebuild
    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
        "/var/lib/systemd/timers"
      ];
      files = [
        "/etc/machine-id"
        { file = "/etc/ssh/ssh_host_ed25519_key"; parentDirectory = { mode = "0755"; }; }
        "/etc/ssh/ssh_host_ed25519_key.pub"
        { file = "/etc/ssh/ssh_host_rsa_key"; parentDirectory = { mode = "0755"; }; }
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
      users.jake = {
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
          ".mozilla"
          "worktrees"
          ".steam"
          ".local/share/Steam"
          ".config/1Password"
          ".config/spotify"
          ".local/state/nvim"
          ".local/state/wireplumber"
          ".cache/cliphist"
          ".cache/spotify"
          ".config/dconf"
          ".local/share/direnv"
          ".local/share/zoxide"
          ".local/share/PrismLauncher"
          ".thunderbird"
          ".claude"
        ];
        files = [
          ".zsh_history"
          ".bash_history"
          "Downloads/.keep"
          ".claude.json"
        ];
      };
    };
  };
}
