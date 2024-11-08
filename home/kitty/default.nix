{ ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font";
      size = 12.0;
    };
    shellIntegration = {
      enableFishIntegration = true; 
    };
    extraConfig = ''
      enable_audio_bell no
    '';
  };
}
