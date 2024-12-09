rec {
  base = {
    allowUnfree = true;
    username = "jake";
    homeDirectory = "/home/jake";
  };
  nixOSLenovo = base // {
    system = "x86_64-linux";
  };
  workMac = base // {
    system = "aarch64-darwin";
    username = "jakegreenwood";
    homeDirectory = "/usr/jakegreenwood";
  };
}
