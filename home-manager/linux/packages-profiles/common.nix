{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    heroic
    osu-lazer
  ];

  programs.lutris = {
    enable = true;
  };
}
