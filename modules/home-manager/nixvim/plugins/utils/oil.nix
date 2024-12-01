  {
    programs.nixvim = {
      plugins.oil = {
        enable = true;
        settings = {
          skip_confirm_for_simple_edits = true;
          view_options = {
            show_hidden = true;
          };

          use_default_keymaps = false;
          keymaps = {
            "g?" = "actions.show_help";
            "<CR>" = "actions.select";
            "-" = "actions.parent";
            "_" = "actions.open_cwd";
            "g." = "actions.toggle_hidden";
            "<leader>l" = "actions.refresh";
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "-";
          action = ":Oil<CR>";
          options = {
            desc = "Open parent directory";
            silent = true;
          };
        }
      ]; 
    };
  }
