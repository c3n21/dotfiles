{
  pkgs,
  ...
}:
{
  programs = {
    neovim = {
      defaultEditor = true;
      enable = true;
    };
    npm.enable = true;
    fish = {
      enable = true;
    };
  };

  users.users.zhifan = {
    shell = pkgs.fish;
  };
}
