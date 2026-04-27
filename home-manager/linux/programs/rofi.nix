{ pkgs, ... }:
let
  catppuccin-rofi-theme =
    let
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "rofi";
        rev = "71fb15577ccb091df2f4fc1f65710edbc61b5a53";
        sha256 = "03gmrw70m8nm58p30n4v2p18756lx69r25l1ij7idzhc7hb9wmzk";
      };
    in
    pkgs.runCommand "catppuccin-frappe.rasi" { } ''
      cat ${src}/themes/catppuccin-frappe.rasi > $out
      grep -v '@import' ${src}/catppuccin-default.rasi >> $out
    '';
in
{
  programs.rofi = {
    enable = true;
    theme = "${catppuccin-rofi-theme}";
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = true;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
  };
}
