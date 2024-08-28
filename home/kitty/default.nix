{ ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font = {
      name = "FireCode Nerd Font";
      size = 10.0;
    };
    shellIntegration = {
      enableFishIntegration = true; 
    };
  };
}
