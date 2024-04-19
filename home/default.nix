{ inputs, config, pkgs, lib, ... }:

let
  user = config.user; 
in {
  imports = [
    # Include all the modules.
    ./alacritty
    ./direnv
    ./dunst
    ./fish
    ./git
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

  options = {
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Packages to be installed for the user.";
    };
  };

  config = {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "23.11"; 

    # We really want to be sure the user name is set.
    home.username = assert user ? name; user.name;
    home.homeDirectory = user.home;

    home.packages = with pkgs; [
      flatpak
      killall
      htop
    ] ++ config.packages; 
  }; 
}
