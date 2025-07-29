{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    heroic
  ];

  programs.lutris = {
    enable = true;
  };
}
