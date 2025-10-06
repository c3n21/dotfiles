{ lib, pkgs, ... }: {
  imports = [
    ./nixos/framework-13-7040-amd/hardware-configuration.nix
    ./nixos/framework-13-7040-amd/configuration.nix
    home-manager.nixosModules.home-manager
    homeManagerModuleConfiguration
  ];
}

