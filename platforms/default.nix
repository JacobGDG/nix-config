rec {
  base = {
    allowUnfree = true;
    username = "jake";
    homeDirectory = "/home/jake";
    isNixOS = false;
    isDarwin = false;
  };
  nixOSLenovo =
    base
    // {
      system = "x86_64-linux";
      isNixOS = true;
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
