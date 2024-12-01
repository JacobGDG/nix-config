{
  programs.nixvim = {
    opts = {
      showmatch  = true;
      ignorecase = true;
      smartcase  = true;
      
      hlsearch = true;
      incsearch = true;
      
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      shiftwidth = 2;
      autoindent = true;
      
      foldenable = false;

      scrolloff = 3;
      
      hidden = true;
      
      number = true;
      cursorline = true;
      colorcolumn = "+1";
      
      showcmd = true;
      wildmode = "longest,list";
    };
  };
}
