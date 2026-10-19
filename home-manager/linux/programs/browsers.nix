{
  pkgs,
  ...
}:
let
  # Replaces store paths in desktop Exec lines with the bare executable name so
  # URL handlers and application pickers (e.g. Browsers) resolve via $PATH
  # without pinning to ephemeral /nix/store hashes.
  fixDesktopExec =
    pkg:
    pkgs.symlinkJoin {
      name = "${pkg.name}-fixed-desktop";
      paths = [ pkg ];
      postBuild = ''
        for f in $out/share/applications/*.desktop; do
          if [ -L "$f" ]; then
            target=$(readlink -f "$f")
            if grep -q "${pkg}/bin/" "$target"; then
              rm "$f"
              substitute "$target" "$f" --replace-fail "${pkg}/bin/" ""
            fi
          fi
        done
      '';
    };
in
{
  home.packages = with pkgs; [
    browsers
    (fixDesktopExec brave)
    firefox
    chromium
    (fixDesktopExec google-chrome)
    (fixDesktopExec microsoft-edge)

    browsers
  ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "default-web-browser" = [ "software.Browsers.desktop" ];
        "text/html" = [ "software.Browsers.desktop" ];
        "text/xml" = [ "software.Browsers.desktop" ];
        "application/xhtml+xml" = [ "software.Browsers.desktop" ];
        "x-scheme-handler/http" = [ "software.Browsers.desktop" ];
        "x-scheme-handler/https" = [ "software.Browsers.desktop" ];
      };
    };
  };
}
