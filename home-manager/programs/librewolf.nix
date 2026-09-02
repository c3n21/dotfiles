{
  xdg = {
    mimeApps = {
      defaultApplications = {
        "default-web-browser" = [
          "librewolf.desktop"
        ];
        "application/pdf" = [
          "librewolf.desktop"
        ];
        "text/html" = [
          "librewolf.desktop"
        ];
        "text/xml" = [
          "librewolf.desktop"
        ];
        "application/xhtml+xml" = [
          "librewolf.desktop"
        ];
        "application/vnd.mozilla.xul+xml" = [
          "librewolf.desktop"
        ];
        "x-scheme-handler/http" = [
          "librewolf.desktop"
        ];
        "x-scheme-handler/https" = [
          "librewolf.desktop"
        ];
      };
    };
  };

  programs.librewolf = {
    enable = true;

    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;

      # URL bar
      "browser.urlbar.suggest.openpage" = true;
      "browser.urlbar.shortcuts.tabs" = true;
      "browser.urlbar.suggest.engines" = true;
    };
    profiles.default = {
      search = {
        force = true;

        engines = {
          nixpkgs = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            definedAliases = [ "@nixpkgs" ];
          };

          nixoptions = {
            name = "NixOS Options";
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            definedAliases = [ "@nixoptions" ];
          };

          hmoptions = {
            name = "Home Manager Options";
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            definedAliases = [ "@hmoptions" ];
          };
        };
      };
    };
  };
}
