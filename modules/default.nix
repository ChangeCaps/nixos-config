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
    ./monitors
    ./neovim
    ./theme
    ./user
    ./waybar
    ./wlogout
    ./wofi
  ];
}
