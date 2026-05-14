{...}: {
  jg.bootable.nixos = {
    pkgs,
    lib,
    ...
  }: {
    # Networking
    networking.useDHCP = lib.mkDefault true;
    networking.networkmanager.enable = true;

    # Security
    security.rtkit.enable = true;
    security.polkit.enable = true;

    hardware.bluetooth.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Services
    services = {
      printing.enable = true;
      udisks2.enable = true;

      openssh = {
        enable = lib.mkDefault false;
        settings = {
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
        };
      };

      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
  };
}
