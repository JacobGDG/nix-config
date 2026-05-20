{lib, ...}: {
  options = {
    nixpkgsStableVersion = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
    };
  };
}
