{ pkgs, ... }:
{
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      ui-select = {
        enable = true;
      };
      frecency = {
        enable = true;
      };
      fzf-native = {
        enable = true;
      };
    };
    settings = {
      defaults = {
        vimgrep_arguments = [
          "${pkgs.ripgrep}/bin/rg"
          "-L"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
          "--fixed-strings"
        ];
        selection_caret = "  ";
        entry_prefix = "  ";
        layout_strategy = "flex";
        layout_config = {
          horizontal = {
            prompt_position = "top";
          };
        };
        sorting_strategy = "ascending";
      };
      pickers = {
        colorscheme = {
          enable_preview = true;
        };
      };
    };
    keymaps = {
      "<leader>o" = {
        action = "find_files";
        options = {
          desc = "Find file";
        };
      };
      "<leader>f" = {
        action = "live_grep";
        options = {
          desc = "Find string";
        };
      };
      "<leader>b" = {
        action = "buffers";
        options = {
          desc = "Find buffer";
        };
      };
      "<leader>h" = {
        action = "help_tags";
        options = {
          desc = "Get help!";
        };
      };
      "<leader>k" = {
        action = "keymaps";
        options = {
          desc = "Keymaps";
        };
      };
    };
  };
}
