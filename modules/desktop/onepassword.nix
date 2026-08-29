{
  nixpkgs.allowedUnfreePackages = [
    "1password-cli"
    "1password-gui"
    "1password"
  ];

  persist = {
    users = {
      directories = [
        ".config/1Password"
      ];
    };
  };

  flake.modules.nixos.onePassword = {pkgs, ...}: {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = ["jake"];
    };
  };
}
