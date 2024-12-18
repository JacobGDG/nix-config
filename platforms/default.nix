rec {
  base = rec {
    allowUnfree = true;
    username = "jake";
    homeDirectory = "/home/${username}";
    isNixOS = false;
    isDarwin = false;
  };
  nixOSLenovo =
    base
    // {
      system = "x86_64-linux";
      isNixOS = true;
      hostName = "jake-laptop-nixos";
    };
  workMac =
    base
    // {
      system = "aarch64-darwin";
      username = "jakegreenwood";
      homeDirectory = "/Users/jakegreenwood";
      isDarwin = true;
    };
}
