{pkgs, ...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.autoExportHTML" = true;
          "browser.cache.disk.enable" = false; # Be kind to hard drive
          "browser.compactmode.show" = true;
          "browser.search.defaultenginename" = "ddg";
          "browser.search.order.1" = "ddg";
          "browser.startup.homepage" = "https://duckduckgo.com";
          "mousewheel.min_line_scroll_amount" = 50;
          "sidebar.verticalTabs" = true;
          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;

          # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
          # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
          # then have Firefox open on some other workspace.
          "widget.disable-workspace-management" = true;
        };
        search = {
          force = true;
          default = "ddg";
          order = ["ddg" "google"];
        };
      };
    };
  };
}
