{
  persist = {
    files = [
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
    ];
  };

  flake.modules.nixos.core = {lib, ...}: {
    services = {
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
