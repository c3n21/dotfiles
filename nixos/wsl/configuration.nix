# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  ...
}:
{
  wsl.enable = true;
  wsl.defaultUser = "zhifan";
  wsl.wslConf = {
    automount.options = "metadata,uid=1000,gid=100,umask=22,fmask=11";
  };

  wsl = {
    interop = {
      includePath = true;
      register = true;
    };
    docker-desktop.enable = true;
    useWindowsDriver = true;
  };

  environment.systemPackages = with pkgs; [
    wslu
  ];

  programs = {
    neovim = {
      defaultEditor = true;
      enable = true;
    };
    npm.enable = true;

  };

  users.users.zhifan = {
    isNormalUser = true;
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
