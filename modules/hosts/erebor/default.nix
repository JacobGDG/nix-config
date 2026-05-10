{den, ...}: {
  den.hosts.x86_64-linux.erebor.users.jake = {};
  den.homes.x86_64-linux."jake@erebor" = {};

  den.aspects.erebor = {
    includes = [den.provides.hostname (den.provides.tty-autologin "jake")];
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.neovim];
    };
  };
}
