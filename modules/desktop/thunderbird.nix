{
  persist = {
    users = {
      directories = [
        ".thunderbird"
      ];
    };
  };

  flake.modules.homeManager.thunderbird = {...}: {
    programs.thunderbird = {
      enable = true;
      profiles = {};
    };
  };
}
