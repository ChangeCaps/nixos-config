{ config, lib, ... }:

let 
  cfg = config.amd;
in {
  options.amd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AMD gpu drivers";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
