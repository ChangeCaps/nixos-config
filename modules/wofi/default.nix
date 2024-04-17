{ inputs, config, pkgs, ... }: {
  programs.wofi = {
    enable = true;
    style = builtins.readFile ./style.css;
    settings = {
      matching = "fuzzy";
      insensitive = true;
    };
  }; 
}
