{ inputs, config, pkgs, ... }: 

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
 
    ../modules
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;

  user = {
    name = "anon";

    packages = with pkgs; [
      rustup
      obsidian
      renderdoc
      spotify
      reaper
      vesktop
      flatpak
    ];
  };

  monitors = [
    {
      name = "HDMI-A-2";
      position = "0x0";
    }
    {
      name = "DVI-D-1";
      position = "1920x0";
    }
  ];

  nh = {
    flake = "~/dotfiles";
  };

  git = {
    userName = "Hjalte Nannestad";
    userEmail = "hjalte.nannestad@gmail.com";
  };  
}
