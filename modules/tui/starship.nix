# TODO: starship colours are stubbed — wire up nix-colors when migrated
let
  # Nord palette stubs — replace with nix-colors when migrated
  c = {
    base00 = "#2e3440";
    base01 = "#3b4252";
    base02 = "#434c5e";
    base03 = "#4c566a";
    base04 = "#d8dee9";
    base05 = "#e5e9f0";
    base0A = "#ebcb8b";
    base0C = "#88c0d0";
  };
in
  {jg, ...}: {
    jg.tui.includes = [jg.starship];
    jg.starship.homeManager = {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = builtins.concatStringsSep "" [
            "[](fg:${c.base01} bg:${c.base01})"
            "$username"
            "[](fg:${c.base01} bg:${c.base02})"
            "$directory"
            "[](fg:${c.base02} bg:${c.base0C})"
            "$git_branch"
            "$git_status"
            "$git_state"
            "[ ](fg:${c.base0C})"
            "$fill"
            "[](fg:${c.base01})"
            "$time"
            "$nix_shell"
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
            style_user = "fg:${c.base04} bg:${c.base01}";
            style_root = "fg:${c.base04} bg:${c.base01}";
            format = "[$user ]($style)";
            disabled = false;
          };
          directory = {
            style = "fg:${c.base04} bg:${c.base02}";
            format = "[ $path ]($style)";
            disabled = false;
            truncate_to_repo = false;
            truncation_symbol = "…/";
            fish_style_pwd_dir_length = 1;
          };
          git_branch = {
            symbol = "";
            style = "fg:${c.base00} bg:${c.base0C}";
            format = "[ $symbol $branch ]($style)";
            disabled = false;
          };
          git_status = {
            style = "fg:${c.base00} bg:${c.base0C}";
            format = "[-$all_status$ahead_behind ]($style)";
            disabled = false;
            diverged = "  \${ahead_count} \${behind_count}";
            ahead = "  \${count}";
            behind = "  \${count}";
            modified = "  \${count}";
            staged = " 󰳻 \${count}";
            untracked = "  \${count}";
            deleted = "  \${count}";
            conflicted = "  \${count}";
            stashed = " 󱉼 \${count}";
            renamed = " 󰑌 \${count}";
          };
          git_state = {
            disabled = false;
            style = "fg:${c.base00} bg:${c.base0C}";
            format = "[\\($state - $progress_current/$progress_total\\)]($style)";
          };
          nix_shell = {
            disabled = false;
            format = "[ $state \\($name\\) ]($style)";
            style = "fg:${c.base00} bg:${c.base0C}";
          };
          kubernetes = {
            style = "fg:${c.base04} bg:#326ce5";
            format = "[ k8s: $context \\($namespace\\) ]($style)";
            detect_env_vars = ["KUBE_PROMPT"];
            disabled = false;
          };
          golang = {
            symbol = "";
            style = "fg:${c.base04} bg:#007d9c";
            format = "[ $symbol ($version) ]($style)";
            disabled = false;
          };
          lua = {
            symbol = "";
            style = "fg:${c.base04} bg:#000080";
            format = "[ $symbol ($version) ]($style)";
            disabled = false;
          };
          nodejs = {
            symbol = "";
            style = "fg:${c.base04} bg:#5fa04e";
            format = "[ $symbol ($version) ]($style)";
            disabled = false;
          };
          package = {
            symbol = "";
            style = "fg:${c.base04} bg:#cb3837";
            format = "[ $symbol ($version) ]($style)";
            disabled = false;
          };
          python = {
            symbol = "";
            style = "fg:${c.base00} bg:#ffdf76";
            format = "[ $symbol ($version) ]($style)";
            disabled = false;
          };
          rust = {
            symbol = "";
            style = "fg:${c.base04} bg:#a72145";
            format = "[ $symbol ($version) ]($style)";
            disabled = false;
          };
          time = {
            disabled = false;
            time_format = "%R";
            style = "fg:${c.base04} bg:${c.base01}";
            format = "[ $time ]($style)";
          };
          cmd_duration = {
            disabled = false;
            style = "fg:${c.base00} bg:${c.base0A}";
            format = "[ $duration ]($style)";
          };
          line_break.disabled = false;
        };
      };
    };
  }
