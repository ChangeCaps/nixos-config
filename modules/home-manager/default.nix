{ inputs, config, pkgs, ... }: 

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.hyprlock.homeManagerModules.default
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11"; 

  home.username = config.user.name;
  home.homeDirectory = config.user.home;

  home.packages = with pkgs; [
    zig
    lazygit
    python3
    killall
    htop
  ] ++ config.user.packages; 
}
