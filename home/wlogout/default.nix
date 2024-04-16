{ inputs, config, pkgs, ... }: {
  programs.wlogout = {
    enable = true;
    
    style = builtins.readFile ./style.css;
  };

  home.file.".config/wlogout/icon".source = ./icon;
}
