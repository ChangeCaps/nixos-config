{ inputs, config, pkgs, lib, ... }:

let 
  cfg = config.nh;
in {
  options.nh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the nh package";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.nh ];
    })
    
    (lib.mkIf (cfg.enable && config.flake != null) {
      fish.sessionVariables = {
        FLAKE = "${config.flake}";
      };
    })
  ];
}
