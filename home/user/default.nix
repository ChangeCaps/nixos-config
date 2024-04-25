{ inputs, config, pkgs, lib, ... }:

{
  # This is configurations for the user.
  options.user = {
    name = lib.mkOption {
      type = lib.types.str;
      example = "john";
      description = "The name of the user.";
    };

    home = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.user.name}";
      description = "The home directory of the user.";
    }; 
  };
}
