{
  den,
  jg,
  ...
}: {
  den.hosts.x86_64-linux."jake-laptop-nixos".users.jake = {};
  den.homes.x86_64-linux."jake@jake-laptop-nixos" = {};

  den.aspects."jake-laptop-nixos" = {
    includes = [
      den.provides.hostname
      (den.provides.tty-autologin "jake")
      jg.linux
      jg.bootable
      jg.battery
      jg.secrets
      jg.wireguard
      jg.homelab
    ];
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.neovim];
      users.users.jake.extraGroups = ["networkmanager" "wheel"];
    };
  };
}
