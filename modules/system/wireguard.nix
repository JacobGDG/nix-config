{
  # Interfaces are exposed as wg-quick-<name> services, which wg-manager discovers.
  flake.modules.nixos.wireguard = {
    inputs,
    config,
    lib,
    pkgs,
    ...
  }: let
    systemctl = "${config.systemd.package}/bin/systemctl";
    wg-manager = pkgs.writeShellApplication {
      name = "wg-manager";
      runtimeInputs = with pkgs; [config.systemd.package coreutils gawk gnugrep gnused];
      # we must reference the suid wrapper directory to use the Set-UID permission
      # Passing the sudo package would fail with "sudo must be owned by uid 0 and have the setuid bit set"
      # ie -r-s--x--x https://linuxvox.com/blog/s-in-file-permissions-linux/
      text = ''
        PATH="$PATH:/run/wrappers/bin"
        ${builtins.readFile ./wireguard/wg-manager.sh}
      '';
    };
    wg-waybar = pkgs.writeShellApplication {
      name = "wg-waybar";
      runtimeInputs = [wg-manager pkgs.gawk];
      text = builtins.readFile ./wireguard/wg-waybar.sh;
    };
    wg-menu = pkgs.writeShellApplication {
      name = "wg-menu";
      runtimeInputs = [wg-manager pkgs.walker pkgs.gnugrep];
      text = builtins.readFile ./wireguard/wg-menu.sh;
    };
    wg-menu-desktop = pkgs.makeDesktopItem {
      name = "wg-menu";
      desktopName = "WireGuard - Select";
      comment = "Connect to a WireGuard interface";
      exec = "${wg-menu}/bin/wg-menu";
      icon = "network-vpn";
      categories = ["Network"];
    };
  in {
    age.secrets = {
      publicWgConfig = {
        file = "${inputs.secrets}/public_wg_config.conf.age";
        mode = "0400";
        owner = "root";
      };
      homeWgConfig = {
        file = "${inputs.secrets}/home_wg_config.conf.age";
        mode = "0400";
        owner = "root";
      };
    };

    networking.wg-quick.interfaces = {
      public = {
        autostart = false;
        configFile = config.age.secrets.publicWgConfig.path;
      };
      home = {
        autostart = false;
        configFile = config.age.secrets.homeWgConfig.path;
      };
    };

    environment.systemPackages = [wg-manager wg-waybar wg-menu wg-menu-desktop];

    security.sudo.extraRules = [
      {
        groups = ["wheel"];
        commands = lib.concatMap (iface:
          map (action: {
            command = "${systemctl} ${action} wg-quick-${iface}";
            options = ["NOPASSWD"];
          }) ["start" "stop"])
        (lib.attrNames config.networking.wg-quick.interfaces);
      }
    ];
  };
}
