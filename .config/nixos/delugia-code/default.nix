{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "delugia-code-complete";
  dontBuild = true;
  version = "2111.01.2";

# fetchFromGitHub is a build support function that fetches a GitHub
# repository and extracts into a directory; so we can use it
# fetchFromGithub is actually a derivation itself :)
  src = pkgs.fetchzip {
    url = "https://github.com/adam7/delugia-code/releases/download/v${version}/delugia-complete.zip";
    sha256 = "Xjp5IJ+fs9aBTMUSrRosZWGIsBJ6uDg1M3AFk6ALTVA=";
  };

  installPhase = ''
    install -m444 -Dt $out/share/fonts/truetype $src/*.ttf
  '';

   meta = with pkgs.lib; {
    description = "Cascadia Code + Nerd Fonts";
    longDescription = "Cascadia Code + Nerd Fonts";
    homepage = "https://github.com/adam7/delugia-code";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
