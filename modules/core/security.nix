{
  flake.modules.nixos.core = {pkgs, ...}: {
    security.rtkit.enable = true;
    security.polkit.enable = true;

    # Compromised eMudhra intermediates: https://emudhra.we-have-a-problem.com/
    # TODO: remove once nixpkgs cacert is built from NSS >= 3.131.1
    security.pki.caCertificateBlacklist = [
      "emSign ECC Root CA - G3"
      "Comodo AAA Services root"
    ];

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
  };
}
