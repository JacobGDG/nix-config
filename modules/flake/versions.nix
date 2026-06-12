{lib, ...}: {
  options = {
    nixpkgsStableVersion = lib.mkOption {
      type = lib.types.str;
      default = "26.05";
    };
  };
}
