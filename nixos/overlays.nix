{ inputs }:
final: prev:
let
  contents = final.appimageTools.extract {
    pname = "neovide-nightly";
    version = "nightly";
    src = inputs.neovide-nightly;
  };
in
{
  nerd-fonts = prev.nerd-fonts // {
    delugia-code = final.callPackage ./delugia-code/default.nix { pkgs = final; };
  };

  dotfiles = {
    niri-autostart = final.callPackage ./packages/niri-autostart.nix { };
    neovide-nightly = final.appimageTools.wrapType2 {
      pname = "neovide";
      version = "nightly";

      src = inputs.neovide-nightly;

      extraInstallCommands = ''
        install -m 444 -D \
          ${contents}/neovide.desktop \
          $out/share/applications/neovide.desktop

        install -m 444 -D \
          ${contents}/neovide.svg \
          $out/share/icons/hicolor/scalable/apps/neovide.svg
      '';

      meta = prev.neovide.meta // {
        mainProgram = "neovide";
      };
    };
    agy-acp-server = final.callPackage ./packages/agy-acp-server.nix { pkgs = final; };
  };
}
