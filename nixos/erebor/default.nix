{mylib, ...}: {
  imports = [../common] ++ mylib.scanPaths ./.;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";

  myModules.nixOS = {
    nvidia.enable = true;
  };
}
