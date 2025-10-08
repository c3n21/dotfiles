{
  nixos-hardware,
  disko,
  home-manager,
  niri,
  lanzaboote,
  ...
}:
{
  system = "x86_64-linux";

  modules = [
    nixos-hardware.nixosModules.framework-13-7040-amd
    # disko.nixosModules.disko
    ../common/fish.nix
    ../common/nixpkgs-configuration.nix
    ../common/distributed-builds.nix

    ./hardware-configuration.nix
    ./configuration.nix
    # TODO: enable when the config is ready
    # ../framework-13-7040-amd/disko.nix

    ../firewall.nix
    ../desktop.nix
    ../specialisations.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.users.zhifan = ./home-manager/home.nix;
    }

    {
      home-manager.users.zhifan = ./home-manager/linux/packages-profiles/gaming.nix;
    }

    {

      # home-manager modules must be put there
      home-manager.users.zhifan.imports = [
        niri.homeModules.niri
      ];
    }

    {
      home-manager.users.zhifan = ./home-manager/linux;
    }

    {
      specialisation.niri.configuration.home-manager.users.zhifan =
        ./home-manager/linux/specialisations/niri.nix;
      specialisation.hyprland.configuration.home-manager.users.zhifan =
        ./home-manager/linux/specialisations/hyprland.nix;
    }

    lanzaboote.nixosModules.lanzaboote
    ../common/secure-boot.nix
    {
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    }
    {
      networking = {
        hostName = "zenuko"; # Define your hostname.
      };
    }
    {
      nixpkgs.overlays = [
        niri.overlays.niri
      ];

    }
  ];
}
