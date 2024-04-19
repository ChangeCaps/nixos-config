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

    flake = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "~/dotfiles";
      description = "The flake to use for nh, this will set the `FLAKE` environment variable";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.nh ];
    })
    
    (lib.mkIf (cfg.enable && cfg.flake != null) {
      fish.sessionVariables = {
        FLAKE = cfg.flake;
      };
    })
  ];
}
