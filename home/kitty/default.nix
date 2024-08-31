{ ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font";
      size = 10.0;
    };
    shellIntegration = {
      enableFishIntegration = true; 
    };
  };
}
