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
      pkgs,
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
              "/var/db/sudo/lectured"
              "/var/lib/bluetooth"
              "/var/lib/nixos"
              "/var/lib/systemd/backlight"
              "/var/lib/systemd/coredump"
              "/var/lib/systemd/timers"
              "/var/log"
            ]
            ++ outerConfig.persist.directories;
          files =
            [
              "/etc/machine-id"
            ]
            ++ outerConfig.persist.files;
          users.jake = {
            directories = [
              ".cache/tealdeer"
              ".config/dconf"
              ".config/systemd"
              ".local/share/PrismLauncher"
              ".local/share/applications"
              ".local/share/direnv"
              ".local/state/nix"
              ".local/state/wireplumber"
              {
                directory = ".ssh";
                mode = "0700";
              }
            ];
            files = [
              ".bash_history"
              "Downloads/.keep"
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

      systemd.user.services.home-manager-activate = {
        description = "Activate home-manager on login";
        wantedBy = ["default.target"];
        # uwsm starts in parallel with the user manager, so hold the compositor
        # (and graphical-session.target) until home files and units are linked
        before = ["graphical-session-pre.target"];
        unitConfig.ConditionFileIsExecutable = "%h/.local/state/nix/profiles/home-manager/activate";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.bash}/bin/bash %h/.local/state/nix/profiles/home-manager/activate";
          # While the user manager is "starting", "home-manager activate" skips its systemd reload,
          # leaving units stale. Reload explicitly once activation is complete.
          ExecStartPost = "${nixosConfig.systemd.package}/bin/systemctl --user daemon-reload";
          Environment = "PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/run/wrappers/bin";
        };
      };
    };
  };
}
