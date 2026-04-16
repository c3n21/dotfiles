# This imports every configuration that should be used on
# a NixOS installation
{
  imports = [
    ./distributed-builds.nix
    ./fish.nix
    ./secure-boot.nix
    ./editor.nix
    ./nix.nix
  ];
}
