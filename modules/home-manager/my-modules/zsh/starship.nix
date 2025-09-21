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
          "[](fg:#0969da bg:#0969da)"
          "$username"
          "[](fg:#0969da bg:#eac54f)"
          "$directory"
          "[](fg:#eac54f bg:#e44729)"
          "$git_branch"
          "$git_status"
          "[ ](fg:#e44729)"
          "$fill"
          "[](fg:#8250df)"
          "$time"
          # "$all"
          "$kubernetes"
          "$golang"
          "$lua"
          "$nodejs"
          "$package"
          "$python"
          "$rust"
          "[](fg:yellow bg:#8250df)"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];

        username = {
          show_always = true;
          style_user = "fg:#ffffff bg:#0969da";
          style_root = "fg:#ffffff bg:#0969da";
          format = "[$user ]($style)";
          disabled = false;
        };

        directory = {
          style = "fg:#000000 bg:#eac54f";
          format = "[ $path ]($style)";
          disabled = false;
          truncate_to_repo = false;
          truncation_symbol = "…/";
          fish_style_pwd_dir_length = 1;
        };

        git_branch = {
          symbol = "";
          style = "fg:#ffffff bg:#e44729";
          format = "[ $symbol ]($style)";
          disabled = false;
        };

        git_status = {
          style = "fg:#ffffff bg:#e44729";
          format = "[$all_status$ahead_behind ]($style)";
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

        # Start languages and tools #

        # https://github.com/starship/starship/issues/840
        kubernetes = {
          style = "fg:#ffffff bg:#326ce5";
          format = "[ k8s: $context \($namespace\) ]($style)";
          detect_env_vars = ["KUBE_PROMPT"];
          disabled = false;
        };

        golang = {
          symbol = "";
          style = "fg:#ffffff bg:#007d9c";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        lua = {
          symbol = "";
          style = "fg:#ffffff bg:#000080";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        nodejs = {
          symbol = "";
          style = "fg:#ffffff bg:#5fa04e";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        package = {
          symbol = "";
          style = "fg:#ffffff bg:#cb3837";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        python = {
          symbol = "";
          style = "fg:#000000 bg:#ffdf76";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        rust = {
          symbol = "";
          style = "fg:#ffffff bg:#a72145";
          format = "[ $symbol ($version) ]($style)";
          disabled = false;
        };

        # End languages and tools #

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "fg:#ffffff bg:#8250df";
          format = "[ $time ]($style)";
        };

        cmd_duration = {
          disabled = false;
          style = "fg:#000000 bg:yellow";
          format = "[ $duration ]($style)";
        };

        line_break = {
          disabled = false;
        };
      };
    };
  };
}
