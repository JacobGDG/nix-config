{
  programs.nixvim.keymaps = [
    { 
      mode = "i";
      key = "kj";
      action = "<ESC>:w<CR>";
      options = {
        desc = "Save file without ESC";
      };
    }
    { 
      mode = "n";
      key = "<leader>s";
      action = "\"_diwP";
      options = {
        desc = "Stamp default register onto word";
      };
    }
    { 
      mode = "n";
      key = "<Up>";
      action = "<Nop>";
      options = {
        desc = "NO ARROWS";
        silent = true;
      };
    }
    { 
      mode = "n";
      key = "<Down>";
      action = "<Nop>";
      options = {
        desc = "NO ARROWS";
        silent = true;
      };
    }
    { 
      mode = "n";
      key = "<Left>";
      action = "<Nop>";
      options = {
        desc = "NO ARROWS";
        silent = true;
      };
    }
    { 
      mode = "n";
      key = "<Right>";
      action = "<Nop>";
      options = {
        desc = "NO ARROWS";
        silent = true;
      };
    }
  ];
}
