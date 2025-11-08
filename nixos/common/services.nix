{lib, ...}: {
  services = {
    printing.enable = true; # Enable CUPS to print documents.
    udisks2.enable = true; # for removable media

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
}
