{ inputs, config, pkgs, lib, ... }: 

{
  options.fish = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fish shell";
    };

    sessionVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Fish shell session variables";
    };
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;
      shellInit = 
        let 
          sessionVariables = lib.concatLines (
            lib.mapAttrsToList 
              ( name: value: "set -x ${name} ${value}" ) 
              config.fish.sessionVariables
          );
        in ''
          # set session variables
          ${sessionVariables}

          # hook direnv into fish
          direnv hook fish | source 
        '';
    };
  };
}
