{ inputs, config, pkgs, lib, ... }:

let 
  cfg = config.nvidia;
in {
  options.nvidia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable NVIDIA drivers";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        open = false;
      };
    })
  ];
}
