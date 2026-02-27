{
  config,
  lib,
  ...
}: let
  cfg = config.myModules.nixOS.firefox;
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
  options.myModules.nixOS.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
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
          # Privacy settings
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
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
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
            install_url = " https://addons.mozilla.org/firefox/downloads/latest/raindropio/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };
  };
}
