{
  # Exposed as an overlay package (not merely on PATH) so other derivations —
  # e.g. tmux's `chime` — can reference it by store path instead of assuming it
  # resolves at runtime.
  nixpkgs.overlays = [
    (final: prev: {
      pane-focused = prev.writeScriptBin "pane-focused" (builtins.readFile ./scripts/pane-focused.sh);
      notify-focused = prev.writeScriptBin "notify-focused" (builtins.readFile ./scripts/notify-focused.sh);
      # Bakes the bundled WAV directory into the script by store path, so the
      # same sounds are used on every machine.
      play-sound = prev.runCommand "play-sound" {} ''
        install -Dm755 ${./scripts/play-sound.sh} $out/bin/play-sound
        substituteInPlace $out/bin/play-sound --replace '@sounds@' '${./sounds}'
      '';
      # tmux alert-bell handler: composes the three helpers above, each linked
      # by store path rather than assumed on PATH.
      tmux-notify = prev.runCommand "tmux-notify" {} ''
        install -Dm755 ${./scripts/tmux-notify.sh} $out/bin/tmux-notify
        substituteInPlace $out/bin/tmux-notify \
          --replace '@pane_focused@' '${final.pane-focused}/bin/pane-focused' \
          --replace '@notify_focused@' '${final.notify-focused}/bin/notify-focused' \
          --replace '@play_sound@' '${final.play-sound}/bin/play-sound'
      '';
    })
  ];

  flake.modules.homeManager.scripts = {pkgs, ...}: let
    mkScript = file: let
      name = builtins.replaceStrings [".sh"] [""] file;
    in
      pkgs.writeScriptBin name (builtins.readFile (./scripts/${file}));
  in {
    home.packages =
      [pkgs.pane-focused pkgs.notify-focused pkgs.play-sound pkgs.tmux-notify]
      ++ map mkScript [
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
