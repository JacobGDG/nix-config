{
  den.aspects.erebor.nixos = {
    config,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid"];
      initrd.kernelModules = [];
      kernelModules = ["kvm-amd"];
      extraModulePackages = [];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/176d3592-48f9-4ac4-af40-954c91a7303e";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/0586-ADD2";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/c7a73c27-9efd-4f7e-bcb9-e8f471cf7d02";}
    ];

    hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };
}
