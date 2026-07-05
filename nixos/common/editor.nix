{ pkgs, ... }:
let
  neovim = pkgs.neovim-nightly;
in
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

  environment.systemPackages = [ neovim ];

  environment.sessionVariables.EDITOR = "${neovim}/bin/nvim";
}
