{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "niri-autostart";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "partanskiy";
    repo = "niri-autostart";
    rev = "v${version}";
    hash = "sha256-RvonnRhASLsNIjAHSNlF0B5cWzx7DNbU7z1Xx/Mo9mw=";
  };

  cargoHash = "sha256-fXpjAWkqGupx4rdVmJ9C8M3V8QmfqladYAxJ9LfaEAk=";

  meta = {
    description = "Declarative autostart and layout restoration for niri";
    homepage = "https://github.com/partanskiy/niri-autostart";
    license = lib.licenses.gpl3Only;
    mainProgram = "niri-autostart";
    platforms = lib.platforms.linux;
  };
}
