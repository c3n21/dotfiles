{ pkgs, ... }:
{
  programs = {
    neovim = {
      enable = false;
      defaultEditor = false;
    };
    nano = {
      enable = false;
    };
  };

  environment.systemPackages = [ pkgs.neovim ];
}
