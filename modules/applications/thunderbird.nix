{...}: {
  # TODO: configure thunderbird profiles
  jg.thunderbird.homeManager = {
    programs.thunderbird = {
      enable = true;
      profiles = {};
    };
  };
}
