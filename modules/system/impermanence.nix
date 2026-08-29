{
  lib,
  config,
  ...
}: {
  options = {
    persist = {
      directories = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        default = [];
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        default = [];
      };
      users = {
        directories = lib.mkOption {
          type = lib.types.listOf lib.types.anything;
          default = [];
        };
        files = lib.mkOption {
          type = lib.types.listOf lib.types.anything;
          default = [];
        };
      };
    };
  };

  config = let
    outerConfig = config;
  in {
    flake-file.inputs.impermanance = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };

    flake.modules.nixos.impermanance = {
      inputs,
      lib,
      ...
    } @ nixosArgs: let
      nixosConfig = nixosArgs.config;
      normalUsers = lib.filterAttrs (_: u: u.isNormalUser) nixosConfig.users.users;
    in {
      imports = [inputs.impermanance.nixosModules.impermanence];

      fileSystems."/persist".neededForBoot = true;

      # Files must be manually copied to avoid clashes
      # 1. Copy/touch to /persist/path/to/file
      # 2. Remove from root
      # 3. Rebuild
      environment.persistence."/persist" = lib.mkMerge [
        {
          enable = true;
          hideMounts = true;
          directories =
            [
              "/var/log"
              "/var/lib/bluetooth"
              "/var/lib/nixos"
              "/var/lib/systemd/coredump"
              "/etc/NetworkManager/system-connections"
              "/var/lib/NetworkManager"
              "/var/lib/systemd/timers"
            ]
            ++ outerConfig.persist.directories;
          files =
            [
              "/etc/machine-id"
              {
                file = "/etc/ssh/ssh_host_ed25519_key";
                parentDirectory = {mode = "0755";};
              }
              "/etc/ssh/ssh_host_ed25519_key.pub"
              {
                file = "/etc/ssh/ssh_host_rsa_key";
                parentDirectory = {mode = "0755";};
              }
              "/etc/ssh/ssh_host_rsa_key.pub"
            ]
            ++ outerConfig.persist.files;
          users.jake = {
            directories = [
              {
                directory = ".ssh";
                mode = "0700";
              }
              ".mozilla"
              "worktrees"
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
              ".local/share/applications"
            ];
            files = [
              ".zsh_history"
              ".bash_history"
              "Downloads/.keep"
              ".claude.json"
            ];
          };
        }
        {
          users =
            lib.mapAttrs (_: _: {
              directories = outerConfig.persist.users.directories;
              files = outerConfig.persist.users.files;
            })
            normalUsers;
        }
      ];
    };
  };
}
