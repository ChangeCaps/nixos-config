{ inputs, config, pkgs, ... }: {
  programs.fish = {
    enable = true; 
    shellInit = ''
      # hook direnv into fish
      direnv hook fish | source 
    '';
  };
}
