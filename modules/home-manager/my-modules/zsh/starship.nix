{
  config,
  lib,
  mylib,
  pkgs,
  ...
}: let
  cfg = config.myModules.zsh.starship;
in {
  config = lib.mkIf cfg.enable {
    programs.zsh.shellAliases."tg-kube" = "[ -z $KUBE_PROMPT ] && export KUBE_PROMPT=1 || unset KUBE_PROMPT";

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      # https://starship.rs/config/
      settings = {
        format = lib.concatStrings [
          "[](fg:#${config.colorScheme.palette.base02} bg:#${config.colorScheme.palette.base02})"
          "$username"
          "[](fg:#${config.colorScheme.palette.base02} bg:#${config.colorScheme.palette.base03})"
          "$directory"
          "[](fg:#${config.colorScheme.palette.base03} bg:#${config.colorScheme.palette.base0C})"
          "$git_branch"
          "$git_status"
          "$git_state"
          "[ ](fg:#${config.colorScheme.palette.base0C})"
          "$fill"
          "[](fg:#${config.colorScheme.palette.base02})"
          "$time"
          # "$all"
          "$kubernetes"
          "$golang"
          "$lua"
          "$nodejs"
          "$package"
          "$python"
          "$rust"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];

        username = {
          show_always = true;
          style_user = "fg:#${config.colorScheme.palette.base05} bg:#${config.colorScheme.palette.base02}";
          style_root = "fg:#${config.colorScheme.palette.base05} bg:#${config.colorScheme.palette.base02}";
          format = "[$user ]($style)";
          disabled = false;
        };

        directory = {
          style = "fg:#${config.colorScheme.palette.base05} bg:#${config.colorScheme.palette.base03}";
          format = "[ $path ]($style)";
          disabled = false;
          truncate_to_repo = false;
          truncation_symbol = "…/";
          fish_style_pwd_dir_length = 1;
        };

        git_branch = {
          symbol = "";
          style = "fg:#${config.colorScheme.palette.base00} bg:#${config.colorScheme.palette.base0C}";
          format = "[ $symbol $branch ]($style)";
          disabled = false;
        };

        git_status = {
          style = "fg:#${config.colorScheme.palette.base00} bg:#${config.colorScheme.palette.base0C}";
          format = "[-$all_status$ahead_behind ]($style)";
          disabled = false;

          diverged = "  \${ahead_count} \${behind_count}";
          ahead = "  \${count}";
          behind = "  \${count}";
          modified = "  \${count}";
          staged = " 󰳻 \${count}";
          untracked = "  \${count}";
          deleted = "  \${count}";
          conflicted = "  \${count}";
          stashed = " 󱉼 \${count}";
          renamed = " 󰑌 \${count}";
        };

        git_state = {
          disabled = false;
          style = "fg:#${config.colorScheme.palette.base00} bg:#${config.colorScheme.palette.base0C}";
          format = "[\\($state - $progress_current/$progress_total\\)]($style)";
        };

        # Start languages and tools #

        # https://github.com/starship/starship/issues/840
        kubernetes = {
          style = "fg:#${config.colorScheme.palette.base05} bg:#326ce5";
          format = "[ k8s: $context \($namespace\) ]($style)";
          detect_env_vars = ["KUBE_PROMPT"];
          disabled = false;
        };

        golang = {
          symbol = "";
          style = "fg:#${config.colorScheme.palette.base05} bg:#007d9c";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        lua = {
          symbol = "";
          style = "fg:#${config.colorScheme.palette.base05} bg:#000080";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        nodejs = {
          symbol = "";
          style = "fg:#${config.colorScheme.palette.base05} bg:#5fa04e";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        package = {
          symbol = "";
          style = "fg:#${config.colorScheme.palette.base05} bg:#cb3837";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        python = {
          symbol = "";
          style = "fg:#${config.colorScheme.palette.base00} bg:#ffdf76";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        rust = {
          symbol = "";
          style = "fg:#${config.colorScheme.palette.base05} bg:#a72145";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        # End languages and tools #

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "fg:#${config.colorScheme.palette.base05} bg:#${config.colorScheme.palette.base02}";
          format = "[ $time ]($style)";
        };

        cmd_duration = {
          disabled = false;
          style = "fg:#${config.colorScheme.palette.base00} bg:#${config.colorScheme.palette.base0A}";
          format = "[ $duration ]($style)";
        };

        line_break = {
          disabled = false;
        };
      };
    };
  };
}
