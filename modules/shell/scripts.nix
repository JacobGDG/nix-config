{
  flake.modules.homeManager.scripts = {pkgs, ...}: let
    mkScript = file: let
      name = builtins.replaceStrings [".sh"] [""] file;
    in
      pkgs.writeScriptBin name (builtins.readFile (./scripts/${file}));
  in {
    home.packages = map mkScript [
      "aws-console.sh"
      "clean-pr.sh"
      "create-app.sh"
      "git-repo.sh"
      "hyprctl-conditional-quit.sh"
      "jira-id.sh"
      "k-cm-dependants.sh"
      "media-control.sh"
      "open-last-url.sh"
      "password_entropy.sh"
      "quick-access-kitty.sh"
      "random.sh"
      "show-keymaps.sh"
      "wg-manager.sh"
      "wg-waybar.sh"
      "wg-wofi.sh"
      "wofi-bookmarks.sh"
    ];
  };
}
