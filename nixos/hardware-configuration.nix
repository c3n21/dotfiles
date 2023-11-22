# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/0190a392-b436-41db-b26b-cf5c1df1ad2a";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-26fb66b7-bbec-4667-be36-7128a1f4f1b1".device = "/dev/disk/by-uuid/26fb66b7-bbec-4667-be36-7128a1f4f1b1";
  boot.initrd.luks.devices."luks-4601e306-2d81-49f6-814a-3f15c1d116b2".device = "/dev/disk/by-uuid/4601e306-2d81-49f6-814a-3f15c1d116b2";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/93E3-EA4A";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/97e305b0-0a56-4aa3-9429-3704399fa897"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp193s0f3u1c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
