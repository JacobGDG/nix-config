{
  programs.nixvim.autoCmd = [
    {
      command = "set relativenumber";
      event = [
        "BufEnter"
        "FocusGained"
        "InsertLeave"
      ];
      pattern = [ "*" ];
    }
    {
      command = "set norelativenumber";
      event = [
        "BufLeave"
        "FocusLost"
        "InsertEnter"
      ];
      pattern = [ "*" ];
    }
  ];
}
