# Modulo HOST NixOS, da importare insieme a microvm.nixosModules.host.
{ pkgs, ... }:
{
  # Serve esclusivamente per collegarsi alla console seriale locale.
  environment.systemPackages = [ pkgs.socat ];

  microvm.vms.finanza = {
    # Riutilizza il nixpkgs gia' selezionato dal flake dell'host.
    inherit pkgs;
    autostart = false;
    restartIfChanged = false;

    # VM costruita insieme al sistema host, senza microvm -u o ISO.
    config = { ... }: {
      imports = [
        ./guest.nix
        ./paperless.nix
        ./firefly.nix
      ];
    };
  };
}
