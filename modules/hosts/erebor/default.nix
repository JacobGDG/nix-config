{den, ...}: {
  den.hosts.x86_64-linux.erebor.users.jake = {};

  den.aspects.erebor = {
    includes = [den.provides.hostname];
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.neovim];
      users.users.jake.initialPassword = "password";
    };
  };
}
