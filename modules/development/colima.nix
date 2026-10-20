{
  flake.modules.homeManager.colima = {pkgs, ...}: {
    home.packages = with pkgs; [
      docker-client
      docker-compose
      docker-buildx
    ];

    home.file = {
      ".docker/cli-plugins/docker-compose".source = "${pkgs.docker-compose}/bin/docker-compose";
      ".docker/cli-plugins/docker-buildx".source = "${pkgs.docker-buildx}/bin/docker-buildx";
    };

    services.colima = {
      enable = true;
      dockerPackage = pkgs.docker-client;
      profiles.default = {
        isService = true;
        isActive = true;
        setDockerHost = true;
        settings = {
          runtime = "docker";
          vmType = "vz";
          mountType = "virtiofs";
          cpu = 4;
          memory = 16;
          disk = 100;
          rootDisk = 20;
          mounts = [
            # lower access, I never work out of ~/ for example
            {
              location = "~/worktrees";
              writable = true;
            }
            # /private/var/folders is macOS's $TMPDIR.
            {
              location = "/private/var/folders";
              writable = true;
            }
            # Lima can't mount single files; needed for ~/.ssh/known_hosts.
            {
              location = "~/.ssh";
              writable = false;
            }
          ];
        };
      };
    };
  };
}
