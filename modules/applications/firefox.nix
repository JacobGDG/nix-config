{...}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  lock-blocked = {
    Value = "blocked";
    Status = "locked";
  };
  lock-empty-string = {
    Value = "";
    Status = "locked";
  };
in {
  jg.firefox.homeManager = {...}: {
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

      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        SearchBar = "unified";

        Preferences = {
          "extensions.pocket.enabled" = lock-false;
          "browser.newtabpage.pinned" = lock-empty-string;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.contentblocking.category" = {
            Value = "strict";
            Status = "locked";
          };
          "extensions.screenshots.disabled" = lock-true;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.ai.control.default" = lock-blocked;
          "browser.ai.control.linkPreviewKeyPoints" = lock-blocked;
          "browser.ai.control.pdfjsAltText" = lock-blocked;
          "browser.ai.control.sidebarChatbot" = lock-blocked;
          "browser.ai.control.smartTabGroups" = lock-blocked;
          "browser.ai.control.translations" = lock-blocked;
        };

        ExtensionSettings = {
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "support@lastpass.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/lastpass-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };
          "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/raindropio/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.autoExportHTML" = true;
          "browser.cache.disk.enable" = false;
          "browser.compactmode.show" = true;
          "browser.search.defaultenginename" = "ddg";
          "browser.search.order.1" = "ddg";
          "browser.startup.homepage" = "https://duckduckgo.com";
          "mousewheel.min_line_scroll_amount" = 50;
          "sidebar.verticalTabs" = true;
          "sidebar.main.tools" = "syncedtabs,jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack";
          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.disable-workspace-management" = true;
          "ui.systemUsesDarkTheme" = 1;
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
