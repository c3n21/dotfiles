{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "agy-acp-server";
  version = "1.2.1";

  src = pkgs.fetchurl {
    url = "https://dl.google.com/agy-extensions/releases/linux/agy-acp-server-1.2.1-linux-x86_64.zip";
    hash = "sha256-n78L1YSiZHgWH2N8q9dRE/clQchC0Uj1eO8aap7cuEM=";
  };

  nativeBuildInputs = [
    pkgs.unzip
    pkgs.makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/antigravity-acp
    mkdir -p $out/bin

    unzip $src -d $out/libexec/antigravity-acp

    chmod +x \
      $out/libexec/antigravity-acp/agy_acp_server.par \
      $out/libexec/antigravity-acp/localharness_external

    makeWrapper \
      $out/libexec/antigravity-acp/agy_acp_server.par \
      $out/bin/agy-acp-server \
      --add-flags "--uid=" \
      --set SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt

    runHook postInstall
  '';
}
