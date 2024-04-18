{ inputs, config, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./direnv
    ./dunst
    ./fish
    ./git
    ./home-manager
    ./hyprland
    ./hyprlock
    ./monitors
    ./neovim
    ./nh
    ./theme
    ./user
    ./waybar
    ./wlogout
    ./wofi
  ];
}
