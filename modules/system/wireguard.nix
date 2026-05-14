{
  inputs,
  jg,
  ...
}: {
  jg.wireguard.includes = [jg.secrets];

  jg.wireguard.nixos = {config, ...}: {
    networking.wg-quick.interfaces = {
      home = {
        autostart = false;
        configFile = config.age.secrets."home.conf".path;
      };
      public = {
        autostart = false;
        configFile = config.age.secrets."public.conf".path;
      };
    };

    age.secrets = {
      "home.conf" = {
        file = "${inputs.mysecrets}/home_wg_config.conf.age";
        mode = "0500";
        owner = "root";
      };
      "public.conf" = {
        file = "${inputs.mysecrets}/public_wg_config.conf.age";
        mode = "0500";
        owner = "root";
      };
    };
  };
}
