{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "catppuccin-macchiato";
  dontBuild = true;
  version = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661";

# fetchFromGitHub is a build support function that fetches a GitHub
# repository and extracts into a directory; so we can use it
# fetchFromGithub is actually a derivation itself :)
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661";
    sha256 = "SjYwyUvvx/ageqVH5MmYmHNRKNvvnF3DYMJ/f2/L+Go=";
  };

# This overrides the shell code that is run during the installPhase.
# By default; this runs `make install`.
# The install phase will fail if there is no makefile; so it is the
# best choice to replace with our custom code.
  # installPhase = ''
  #   mkdir -p $out/share/sddm/themes
  #   cp -aR $src/src/catppuccin-frappe $out/share/sddm/themes/catppuccin-frappe
  #   cp -aR $src/src/catppuccin-latte $out/share/sddm/themes/catppuccin-latte
  #   cp -aR $src/src/catppuccin-macchiato $out/share/sddm/themes/catppuccin-macchiato
  #   cp -aR $src/src/catppuccin-mocha $out/share/sddm/themes/catppuccin-mocha
  # '';
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src/src/${name} $out/share/sddm/themes/${name}
  '';
}
