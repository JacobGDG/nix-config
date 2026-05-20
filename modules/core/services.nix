{
  flake.modules.nixos.core = {lib, ...}: {
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
