{mylib, ...}: {
  imports = [../common] ++ mylib.scanPaths ./.;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  myModules.nixOS = {
    battery.enable = true;
    homelab = {
      enable = true;
      homer.enable = true;
    };
    wireguard = {
      enable = true;
      home.enable = true;
      public.enable = true;
    };
  };
}
