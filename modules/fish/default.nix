{ inputs, config, pkgs, lib, ... }: 

{
  options = {
    fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable fish shell";
      };

      sessionVariables = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Fish shell session variables";
      };
    };
  };

  config = {
    programs.fish = {
      enable = true;
      shellInit = 
        let 
          sessionVariables = builtins.concatStringsSep " " (
            lib.mapAttrsToList (name: value: "${name}=${value}") config.fish.sessionVariables
          );
        in ''
          # hook direnv into fish
          direnv hook fish | source 
        '';
    };
  };
}
