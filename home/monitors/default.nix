{ lib, ... }: 

{
  options.monitors = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "DP-1";
        };

        resolution = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "1920x1080";
        };

        refreshRate = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          example = 60;
        };

        position = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "0x0";
        };

        scale = lib.mkOption {
          type = lib.types.float;
          default = 1.0;
        };

        hdr = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable HDR for the monitor.";
        };

        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        workspace = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "The workspace assigned to the monitor.";
        };
      };
    });

    default = [];
  };
}
