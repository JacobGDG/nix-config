{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ./base.nix
  ];

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home = {
    sessionPath = [
      "/nix/var/nix/profiles/default/bin"
      "/opt/homebrew/bin"
    ];

    packages = with pkgs; [
      jira-cli-go
    ];
  };
}
